import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/urge_technique.dart';

/// T11: 冷水洗脸+自我对话引导页
/// 双重打断：生理（冷水激活）+ 认知（自我对话解离）
/// 阶段1：冷水激活30秒 → 阶段2：认知对话
class SelfDialogueGuidePage extends StatefulWidget {
  final UrgeTechnique technique;
  final VoidCallback? onComplete;
  const SelfDialogueGuidePage({super.key, required this.technique, this.onComplete});

  @override
  State<SelfDialogueGuidePage> createState() => _SelfDialogueGuidePageState();
}

class _SelfDialogueGuidePageState extends State<SelfDialogueGuidePage> {
  int _currentPhase = 1; // 1=冷水激活, 2=认知对话
  int _remainingSeconds = 30;
  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;

  final List<String> _dialogueLines = [
    '这只是神经习惯的回响，不是我的本质',
    '90秒后这个渴望会自然衰减',
    '我选择给前额叶一个机会',
  ];
  int _currentDialogueIndex = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 30;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPhase1() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        _onPhase1Complete();
      }
    });
  }

  void _onPhase1Complete() {
    setState(() {
      _currentPhase = 2;
      _remainingSeconds = _dialogueLines.length * 8;
      _isRunning = false;
    });
  }

  void _startPhase2() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        if (_remainingSeconds > 0 && _remainingSeconds % 8 == 0) {
          _currentDialogueIndex++;
          if (_currentDialogueIndex >= _dialogueLines.length) {
            _currentDialogueIndex = _dialogueLines.length - 1;
          }
        }
      } else {
        _timer?.cancel();
        _onComplete();
      }
    });
  }

  void _onComplete() {
    if (!mounted) return;
    setState(() {
      _isCompleted = true;
      _isRunning = false;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
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
            Icon(Icons.psychology, color: Color(kColorSecondary)),
            SizedBox(width: 8),
            Text('双重打断完成'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '你刚刚完成了一次双重干预：',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text('• 冷水激活 → 副交感神经接管\n• 认知解离 → 前额叶重新上线', style: TextStyle(fontSize: 13)),
            SizedBox(height: 12),
            Text(
              '这不是你的失败，这是神经习惯的回响。\n你的前额叶正在学习新的反应方式。',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Color(kColorTextSecondary),
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
            child: const Text('感觉清醒多了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentPhase == 1
          ? const Color(0xFF1A3A5C)
          : const Color(0xFF1A2E1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _currentPhase == 1 ? '阶段1：冷水激活' : '阶段2：认知对话',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: _isCompleted
            ? _buildCompletedView()
            : _currentPhase == 1
                ? _buildPhase1View()
                : _buildPhase2View(),
      ),
    );
  }

  Widget _buildCompletedView() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Color(kColorAccent), size: 80),
          SizedBox(height: 16),
          Text(
            '双重打断完成',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPhase1View() {
    final progress = 1 - (_remainingSeconds / 30);
    return Column(
      children: [
        const Spacer(),
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Color(kColorSecondary)),
                    ),
                  ),
                  Column(
                    children: [
                      const Text('💧', style: TextStyle(fontSize: 50)),
                      Text(
                        '$_remainingSeconds',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                '冷水敷面，感受温度激活的清醒感',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 48),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '冷激活触发哺乳动物潜水反射\n副交感神经将在30秒内接管',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (!_isRunning)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
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
                onPressed: _startPhase1,
                child: const Text('开始冷水激活', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPhase2View() {
    return Column(
      children: [
        const Spacer(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(13),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.psychology, color: Colors.white, size: 40),
              const SizedBox(height: 16),
              const Text(
                '对自己说',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                '"${_dialogueLines[_currentDialogueIndex]}"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_dialogueLines.length, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= _currentDialogueIndex
                          ? const Color(kColorAccent)
                          : Colors.white24,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Text(
                '认知解离机制',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '命名渴求→激活前额叶监控网络→降低杏仁核激活→减弱渴求的情感强度',
                style: TextStyle(color: Colors.white60, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        if (!_isRunning)
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
                onPressed: _startPhase2,
                child: const Text('开始自我对话', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        const SizedBox(height: 40),
      ],
    );
  }
}