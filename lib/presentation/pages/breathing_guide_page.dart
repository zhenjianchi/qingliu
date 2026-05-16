import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// T4: 90秒呼吸法引导页
/// 呼气延长激活副交感神经，消退渴求高峰
/// 动画：圆形呼吸引导（吸气扩张 → 屏息保持 → 呼气收缩），6轮约90秒
class BreathingGuidePage extends StatefulWidget {
  final VoidCallback? onComplete;
  const BreathingGuidePage({super.key, this.onComplete});

  @override
  State<BreathingGuidePage> createState() => _BreathingGuideState();
}

class _BreathingGuideState extends State<BreathingGuidePage>
    with SingleTickerProviderStateMixin {
  // 6轮呼吸：吸气4s + 屏息2s + 呼气15s = 21s/轮 × 6 = 126s ≈ 90秒有效呼气
  // 设计：每轮21秒，6轮
  static const int rounds = 6;
  static const int inhaleSeconds = 4;
  static const int holdSeconds = 2;
  static const int exhaleSeconds = 15; // 呼气是核心

  late AnimationController _animController;
  late Animation<double> _scaleAnim; // 吸气扩张，呼气收缩

  int _currentRound = 1;
  String _phaseLabel = '准备';
  int _phaseSeconds = 0;
  bool _isRunning = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: exhaleSeconds),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() => _isRunning = true);
    _runRound(1);
  }

  void _runRound(int round) {
    if (round > rounds) {
      _onComplete();
      return;
    }
    setState(() {
      _currentRound = round;
      _phaseLabel = '吸气 $inhaleSeconds秒';
      _phaseSeconds = inhaleSeconds;
    });

    // 吸气动画：0 → 1
    _animController.duration = Duration(seconds: inhaleSeconds);
    _animController.forward(from: 0);

    // 吸气阶段倒计时
    _countdown(inhaleSeconds, () {
      // 屏息
      setState(() {
        _phaseLabel = '屏息';
        _phaseSeconds = holdSeconds;
      });
      _animController.stop();

      _countdown(holdSeconds, () {
        // 呼气
        setState(() {
          _phaseLabel = '呼气 $exhaleSeconds秒';
          _phaseSeconds = exhaleSeconds;
        });
        _animController.duration = Duration(seconds: exhaleSeconds);
        _animController.reverse(from: 1.0);

        _countdown(exhaleSeconds, () {
          // 进入下一轮
          _runRound(round + 1);
        });
      });
    });
  }

  void _countdown(int seconds, VoidCallback onDone) {
    int remaining = seconds;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      remaining--;
      setState(() => _phaseSeconds = remaining);
      if (remaining <= 0) {
        timer.cancel();
        onDone();
      }
    });
  }

  void _onComplete() {
    if (!mounted) return;
    setState(() {
      _isCompleted = true;
      _isRunning = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Color(kColorAccent)),
            SizedBox(width: 8),
            Text('完成得很好'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '渴望高峰通常持续约90秒。\n你刚刚完整经历了一个周期。',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 12),
            Text(
              '副交感神经已被激活，\n皮质醇水平正在下降。\n你做出了一个不同的选择。',
              style: TextStyle(
                fontSize: 13,
                color: Color(kColorTextSecondary),
                fontStyle: FontStyle.italic,
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
            child: const Text('感觉好多了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted && !_isRunning) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCompletionDialog());
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '90秒呼吸法',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (_isRunning)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                '跳过',
                style: TextStyle(color: Colors.white54),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // 呼吸动画圆
            Center(
              child: AnimatedBuilder(
                animation: _scaleAnim,
                builder: (_, __) {
                  return Container(
                    width: 220 * _scaleAnim.value,
                    height: 220 * _scaleAnim.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF4472C4).withAlpha(179),
                          const Color(0xFF4CAF50).withAlpha(128),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4472C4).withAlpha(77),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isRunning ? '$_phaseSeconds' : '▶',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _phaseLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // 轮次指示
            Text(
              '第 $_currentRound / $rounds 轮',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 8),
            // 进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: LinearProgressIndicator(
                value: _currentRound / rounds,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation(Color(kColorAccent)),
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
                    '神经机制',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '呼气延长刺激迷走神经→压力感受器→副交感神经激活。\n这会将身体状态从"交感高唤起"切换为"平静"，打破渴求-注意力循环。',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 开始按钮
            if (!_isRunning && !_isCompleted)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: _startBreathing,
                    child: const Text(
                      '开始呼吸',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}