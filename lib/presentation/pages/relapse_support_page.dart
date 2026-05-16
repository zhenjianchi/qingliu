import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../data/datasources/local_datasource.dart';
import '../../domain/entities/abstinence_record.dart';
import 'package:uuid/uuid.dart';

/// 破戒后支持系统
/// 替代默认的"重置"页面，提供问卷+科学叙事
/// 核心原则：破戒≠失败（Marlatt模型）
class RelapseSupportPage extends StatefulWidget {
  final AbstinenceRecord previousRecord;
  final int previousDays;
  final VoidCallback? onComplete;
  const RelapseSupportPage({
    super.key,
    required this.previousRecord,
    required this.previousDays,
    this.onComplete,
  });

  @override
  State<RelapseSupportPage> createState() => _RelapseSupportPageState();
}

class _RelapseSupportPageState extends State<RelapseSupportPage> {
  final _logger = AppLogger.instance;
  final _uuid = const Uuid();
  final _dataSource = LocalDataSource.instance;

  int _step = 0; // 0=欢迎, 1-5=问卷, 6=叙事, 7=完成

  // 问卷答案
  String? _scenario;    // 触发场景
  final Set<String> _emotions = {};  // 情绪状态
  final Set<String> _techniques = {}; // 尝试的应对方式
  final TextEditingController _learningController = TextEditingController();
  final TextEditingController _improvementController = TextEditingController();

  final List<String> _scenarios = [
    '晚上独自一人时',
    '睡前无聊',
    '压力/焦虑时',
    '看见触发内容',
    '情绪低落时',
    '其他',
  ];

  final List<String> _emotionOptions = [
    '焦虑', '抑郁', '孤独', '无聊', '愤怒', '压力', '其他',
  ];

  final List<String> _techniqueOptions = [
    'T4 90秒呼吸法', 'T5 感官接地', 'T11 冷水+自我对话',
    '冷水洗脸', '爆发性运动', '其他', '未尝试',
  ];

  // 问卷问题
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '这次破戒发生在什么情境下？',
      'type': 'single_choice',
      'field': 'scenario',
      'options': [
        '晚上独自一人时', '睡前无聊', '压力/焦虑时', '看见触发内容', '情绪低落时', '其他',
      ],
    },
    {
      'question': '破戒前你的情绪状态是什么？',
      'type': 'multi_choice',
      'field': 'emotions',
      'options': ['焦虑', '抑郁', '孤独', '无聊', '愤怒', '压力', '其他'],
    },
    {
      'question': '破戒前你尝试了哪些应对方式？',
      'type': 'multi_choice',
      'field': 'techniques',
      'options': [
        'T4 90秒呼吸法', 'T5 感官接地', 'T11 冷水+自我对话',
        '冷水洗脸', '爆发性运动', '其他', '未尝试',
      ],
    },
    {
      'question': '这次破戒中你学到了什么？',
      'type': 'text',
      'field': 'learning',
      'hint': '写下你的发现，例如："我在晚上11点后特别脆弱"...',
      'minLength': 10,
    },
    {
      'question': '下一次遇到类似情境，你会怎么做不同？',
      'type': 'text',
      'field': 'improvement',
      'hint': '写下具体计划，例如："下次晚上10点后，我会打开渴望应对面板"...',
      'minLength': 10,
    },
  ];

  void _nextStep() {
    // 验证当前答案
    if (_step >= 1 && _step <= 5) {
      final q = _questions[_step - 1];
      if (q['type'] == 'single_choice' && _scenario == null) {
        _showError('请选择一个情境');
        return;
      }
      if (q['type'] == 'multi_choice' && _emotions.isEmpty && q['field'] == 'emotions') {
        _showError('请至少选择一种情绪');
        return;
      }
      if (q['type'] == 'text') {
        final text = _learningController.text;
        if (_step == 4 && text.length < 10) {
          _showError('请至少写10个字');
          return;
        }
      }
      if (q['type'] == 'text' && _step == 5) {
        final text = _improvementController.text;
        if (text.length < 10) {
          _showError('请至少写10个字');
          return;
        }
      }
    }

    setState(() => _step++);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(kColorError)),
    );
  }

  void _completeQuestionnaire() async {
    // 保存破戒分析记录
    try {
      await _dataSource.insertTriggerLog({
        'id': _uuid.v4(),
        'timestamp': DateTime.now().toIso8601String(),
        'emotion': _emotions.join(','),
        'urge_level': 10,
        'note': '破戒分析：$_scenario | 学到：${_learningController.text} | 下次：${_improvementController.text}',
        'location': _scenario,
      });
      _logger.info('Relapse analysis saved: scenario=$_scenario', tag: 'RelapseSupport');
    } catch (e, st) {
      _logger.error('Failed to save relapse analysis', error: e, stackTrace: st);
    }

    setState(() => _step = 6);
  }

  void _startNewCycle() {
    // 关闭破戒支持页，用户回到主屏幕
    widget.onComplete?.call();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _learningController.dispose();
    _improvementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      appBar: _step == 0
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: _step == 1
                  ? IconButton(
                      icon: const Icon(Icons.close, color: Color(kColorTextSecondary)),
                      onPressed: () => _showExitDialog(),
                    )
                  : IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(kColorTextSecondary)),
                      onPressed: () => setState(() => _step--),
                    ),
              title: Text(
                _step == 6 ? '理解发生了什么' : '破戒分析',
                style: const TextStyle(color: Color(kColorTextPrimary)),
              ),
              centerTitle: true,
            ),
      body: SafeArea(
        child: _step == 0
            ? _buildWelcome()
            : _step <= 5
                ? _buildQuestion(_step - 1)
                : _step == 6
                    ? _buildScienceNarrative()
                    : _buildComplete(),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('跳过分析？'),
        content: const Text(
          '破戒分析帮助你理解触发模式，\n跳过将直接重置计时器。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('继续分析'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(kColorTextHint),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('跳过'),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite_outline,
              size: 80,
              color: Color(kColorSecondary),
            ),
            const SizedBox(height: 24),
            Text(
              '让我们理解这次发生了什么',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(kColorTextPrimary),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              '破戒是神经习惯的回响，不是你的失败。\n这个分析帮助你下一次做出不同的选择。\n\n大约需要2分钟。',
              style: TextStyle(
                color: Color(kColorTextSecondary),
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(kColorSecondary),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: _nextStep,
                child: const Text(
                  '开始分析',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(int index) {
    final q = _questions[index];
    final type = q['type'] as String;
    final question = q['question'] as String;
    final options = q['options'] as List<String>;

    return Column(
      children: [
        // 进度
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: List.generate(_questions.length, (i) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= index ? const Color(kColorSecondary) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '问题 ${index + 1} / ${_questions.length}',
            style: const TextStyle(color: Color(kColorTextHint), fontSize: 12),
          ),
        ),
        const SizedBox(height: 24),

        // 问题
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(kColorTextPrimary),
                  ),
                ),
                const SizedBox(height: 20),

                if (type == 'single_choice')
                  ...options.map((opt) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildChoiceChip(
                          label: opt,
                          selected: _scenario == opt,
                          onTap: () => setState(() => _scenario = opt),
                        ),
                      )),

                if (type == 'multi_choice')
                  ...options.map((opt) {
                    final isSelected = _emotions.contains(opt) || _techniques.contains(opt);
                    final targetSet = q['field'] == 'emotions' ? _emotions : _techniques;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildChoiceChip(
                        label: opt,
                        selected: isSelected,
                        onTap: () => setState(() {
                          if (isSelected) {
                            targetSet.remove(opt);
                          } else {
                            targetSet.add(opt);
                          }
                        }),
                      ),
                    );
                  }),

                if (type == 'text')
                  TextField(
                    controller: q['field'] == 'learning' ? _learningController : _improvementController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: q['hint'] as String,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // 下一步按钮
        Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(kColorSecondary),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              onPressed: index == 4 ? _completeQuestionnaire : _nextStep,
              child: Text(
                index == 4 ? '完成分析' : '下一步',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? const Color(kColorSecondary).withAlpha(26) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(kColorSecondary) : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? const Color(kColorSecondary) : Colors.grey.shade400,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color(kColorTextPrimary),
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScienceNarrative() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 科学叙事
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(kColorPrimary).withAlpha(26),
                  const Color(kColorSecondary).withAlpha(26),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  '这是神经习惯的回响，不是你的失败。',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(kColorPrimary),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '你的前额叶正在学习一个新的反应方式。\n这需要时间和重复。\n每次你选择用不同的方式应对，\n你就在加强前额叶的抑制控制。',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(kColorTextSecondary),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 进度保留
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(kColorAccent).withAlpha(13),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(kColorAccent)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(kColorAccent)),
                    SizedBox(width: 8),
                    Text(
                      '你仍保有这些',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(kColorAccent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatItem('${widget.previousDays}', '累计天数'),
                    const SizedBox(width: 16),
                    _buildStatItem('$_step', '次学习记录'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 下一步
          const Text(
            '下一步：重新开始',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(kColorTextPrimary),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '你的连续天数已重置，但你的技能和理解仍在。\n从今天开始，继续建立新的神经回路。',
            style: TextStyle(
              color: Color(kColorTextSecondary),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(kColorSecondary),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              onPressed: _startNewCycle,
              child: const Text(
                '重新开始',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(kColorSecondary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(kColorTextSecondary),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplete() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.celebration, color: Color(kColorAccent), size: 80),
          SizedBox(height: 16),
          Text(
            '分析完成',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(kColorTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}