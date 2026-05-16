import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// T5: 感官接地54321引导页
/// 强制重启前额叶，覆盖自动化奖赏回路
/// 分步骤引导：5→4→3→2→1，每步说完才算完成
class GroundingGuidePage extends StatefulWidget {
  final VoidCallback? onComplete;
  const GroundingGuidePage({super.key, this.onComplete});

  @override
  State<GroundingGuidePage> createState() => _GroundingGuideState();
}

class _GroundingGuideState extends State<GroundingGuidePage> {
  int _currentStep = 0; // 0-4 对应 5-4-3-2-1
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<bool> _stepCompleted = List.filled(5, false);
  final FocusNode _focusNode = FocusNode();
  bool _isCompleted = false;
  bool _voiceMode = false;

  // 每步的数量
  final List<int> _stepNumbers = [5, 4, 3, 2, 1];
  final List<String> _stepLabels = [
    '你能看见的事物',
    '你能触摸的东西',
    '你能听见的声音',
    '你能闻到的气味',
    '你能尝到的味道',
  ];

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _completeStep() {
    if (_currentStep >= 5) return;
    setState(() {
      _stepCompleted[_currentStep] = true;
    });

    if (_currentStep < 4) {
      // 下一轮
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _currentStep++);
        }
      });
    } else {
      _onComplete();
    }
  }

  void _onComplete() {
    if (!mounted) return;
    setState(() => _isCompleted = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _showCompletionDialog();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(kColorAccent)),
            SizedBox(width: 8),
            Text('感官接地完成'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '你的前额叶刚刚接管了注意力的控制权。\n通过命名真实感官输入，你切断了自动化奖赏回路的注意力锚点。',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '渴望正在自然衰减。',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(kColorPrimary),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              widget.onComplete?.call();
            },
            child: const Text('感觉平静多了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted && !_isRunning) {
      // handled via timer
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A2E1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '感官接地 5-4-3-2-1',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _voiceMode ? Icons.mic : Icons.keyboard,
              color: Colors.white70,
            ),
            onPressed: () => setState(() => _voiceMode = !_voiceMode),
            tooltip: _voiceMode ? '切换到手动输入' : '切换到语音输入',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 步骤进度指示
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(5, (i) {
                  final isCompleted = _stepCompleted[i];
                  final isCurrent = i == _currentStep;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(kColorAccent)
                            : isCurrent
                                ? const Color(0xFF4CAF50).withAlpha(179)
                                : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text(
              '第 ${_currentStep + 1} / 5 步',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // 主内容区
            Expanded(
              child: _isCompleted
                  ? _buildCompletedView()
                  : _buildStepView(),
            ),
          ],
        ),
      ),
    );
  }

  bool get _isRunning => !_isCompleted;

  Widget _buildCompletedView() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Color(kColorAccent), size: 80),
          SizedBox(height: 16),
          Text(
            '已完成全部5步',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStepView() {
    final step = _currentStep;
    final number = _stepNumbers[step];
    final label = _stepLabels[step];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(),
          // 大数字
          Text(
            '$number',
            style: TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.w100,
              color: const Color(kColorAccent).withAlpha(51),
            ),
          ),
          const SizedBox(height: 8),
          // 步骤标签
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // 输入区域
          if (_voiceMode)
            _buildVoiceInput(step, number)
          else
            _buildManualInput(step, number),

          const SizedBox(height: 24),
          // 完成按钮
          if (_stepCompleted[step])
            const Text(
              '✓ 已完成',
              style: TextStyle(color: Color(kColorAccent), fontSize: 16),
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              onPressed: _completeStep,
              child: Text(
                '我说完了（$number个）',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          const Spacer(),

          // 神经科学说明
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text(
                  '前额叶重启机制',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '命名真实感官输入→激活前额叶注意力网络→抑制杏仁核的威胁/奖赏信号→切断自动化渴求循环',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualInput(int step, int count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '说出 $count 个，例如：',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controllers[step],
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: _getPlaceholder(step),
              hintStyle: TextStyle(color: Colors.white.withAlpha(77)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withAlpha(51)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white.withAlpha(51)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(kColorAccent)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceInput(int step, int count) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.mic, color: Color(kColorAccent), size: 40),
          const SizedBox(height: 8),
          Text(
            '请大声说出 $count 个${
              ['事物', '东西', '声音', '气味', '味道'][step]
            }',
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            '（语音模式：说出即可，不需要打字）',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _getPlaceholder(int step) {
    final placeholders = [
      '窗户、桌子、手机、墙上的画、灯 ...',
      '衣服、桌面、手臂、杯子、键盘 ...',
      '空调声、说话声、脚步声、钟表声 ...',
      '咖啡味、空气味、洗衣液味 ...',
      '水的味道、呼吸的味道 ...',
    ];
    return placeholders[step];
  }
}