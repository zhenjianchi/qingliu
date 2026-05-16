import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// T11: 冷水洗脸 + 自我对话
/// 最完整方案：冷激活（生理）+ 认知解离（心理）双重打断
/// 阶段1：冷水激活（30-60秒）
/// 阶段2：认知对话（标准化自我对话模板）
class SelfDialoguePage extends StatefulWidget {
  final VoidCallback? onComplete;
  const SelfDialoguePage({super.key, this.onComplete});

  @override
  State<SelfDialoguePage> createState() => _SelfDialoguePageState();
}

class _SelfDialoguePageState extends State<SelfDialoguePage> {
  int _phase = 1; // 1=冷水, 2=对话
  int _countdown = 30;
  Timer? _timer;
  bool _coldDone = false;
  bool _dialogueDone = false;

  // 标准化自我对话模板
  final List<String> _dialogueLines = [
    '"这只是一种神经习惯的回响，不是我的本质。"',
    '"渴望高峰通常持续90秒，我现在处于衰减阶段。"',
    '"我的前额叶正在学习一个新的反应方式。"',
    '"我选择给前额叶一个机会，而不是自动化反应。"',
  ];
  int _dialogueIndex = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startColdPhase() {
    setState(() {
      _phase = 1;
      _countdown = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _timer?.cancel();
        _onColdComplete();
      }
    });
  }

  void _onColdComplete() {
    if (!mounted) return;
    setState(() {
      _coldDone = true;
      _phase = 2;
      _dialogueIndex = 0;
    });
  }

  void _advanceDialogue() {
    if (_dialogueIndex < _dialogueLines.length - 1) {
      setState(() => _dialogueIndex++);
    } else {
      setState(() => _dialogueDone = true);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _showCompletionDialog();
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.self_improvement, color: Color(kColorAccent)),
            SizedBox(width: 8),
            Text('双重打断完成'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '你刚刚完成了最完整的渴望打断方案：',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              '1. 冷水激活 → 迷走神经 → 副交感接管\n2. 认知解离 → 前额叶 → 抑制控制恢复',
              style: TextStyle(
                fontSize: 13,
                color: Color(kColorTextSecondary),
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '这不是意志力的胜利，\n这是神经系统的重新校准。\n你正在改变大脑。',
              style: TextStyle(
                fontSize: 15,
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
            child: const Text('我感觉清醒多了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2233),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '冷水 + 自我对话',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: _phase == 1 ? _buildColdPhase() : _buildDialoguePhase(),
      ),
    );
  }

  Widget _buildColdPhase() {
    return Column(
      children: [
        const Spacer(),
        // 冷水动画
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // 水滴动画
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (_, v, __) => Container(
                      width: 180 * v,
                      height: 180 * v,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF64B5F6).withAlpha(102),
                            const Color(0xFF42A5F5).withAlpha(51),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1565C0).withAlpha(77),
                      border: Border.all(
                        color: const Color(0xFF64B5F6).withAlpha(128),
                        width: 3,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.water_drop, color: Colors.white70, size: 40),
                        const SizedBox(height: 4),
                        Text(
                          '$_countdown',
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          '秒',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                '将冷水敷在脸上',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '感受温度激活清醒感',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
        const Spacer(),

        // 神经科学说明
        Container(
          margin: const EdgeInsets.all(kPaddingLarge),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Text(
                '双重机制',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '冷水刺激→三叉神经→迷走神经→副交感激活\n同时：冷感→前额叶激活→抑制控制增强',
                style: TextStyle(color: Colors.white60, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 开始按钮
        if (!_coldDone)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: _startColdPhase,
                child: const Text(
                  '开始计时 30秒',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        else
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 48),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(kColorAccent).withAlpha(26),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(kColorAccent)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Color(kColorAccent)),
                SizedBox(width: 8),
                Text(
                  '冷水阶段完成',
                  style: TextStyle(
                    color: Color(kColorAccent),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDialoguePhase() {
    return Column(
      children: [
        const Spacer(),
        // 镜子图标
        const Icon(Icons.face, color: Colors.white38, size: 60),
        const SizedBox(height: 16),
        const Text(
          '对自己说',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 32),

        // 当前对话行
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(13),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(kColorAccent).withAlpha(77),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _dialogueLines[_dialogueIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // 进度指示
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_dialogueLines.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i <= _dialogueIndex ? 20 : 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _dialogueIndex
                            ? const Color(kColorAccent)
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_dialogueIndex + 1} / ${_dialogueLines.length}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),

        // 说明
        Container(
          margin: const EdgeInsets.all(kPaddingLarge),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '大声朗读或默念这些句子。\n认知解离是将"我渴望"转化为"我正在经历一个神经习惯的激活"——这是打破自动化的关键。',
            style: TextStyle(color: Colors.white60, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),

        // 下一步按钮
        if (!_dialogueDone)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(kColorAccent),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: _advanceDialogue,
                child: Text(
                  _dialogueIndex < _dialogueLines.length - 1 ? '下一句' : '完成',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        const SizedBox(height: 40),
      ],
    );
  }
}