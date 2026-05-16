import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../domain/entities/urge_technique.dart';

/// Technique execution guide page with countdown timer
class TechniqueGuidePage extends StatefulWidget {
  final UrgeTechnique technique;
  const TechniqueGuidePage({super.key, required this.technique});
  @override
  State<TechniqueGuidePage> createState() => _TechniqueGuidePageState();
}

class _TechniqueGuidePageState extends State<TechniqueGuidePage> {
  final _logger = AppLogger.instance;
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  bool _isCompleted = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.technique.durationSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        _onCompleted();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _resumeTimer() {
    setState(() => _isPaused = false);
    _startTimer();
  }

  void _onCompleted() {
    setState(() => _isCompleted = true);
    _logger.info(
      'Technique ${widget.technique.id} completed by user',
      tag: 'TechniqueGuide',
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Color(kColorAccent)),
            SizedBox(width: 8),
            Text('做得很好！'),
          ],
        ),
        content: const Text(
          '你刚刚成功拦截了一次冲动。\n这让你离目标更近一步。\n\n继续加油，你可以的。',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // page
            },
            child: const Text('返回首页'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (_remainingSeconds / widget.technique.durationSeconds);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.technique.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (_isRunning && !_isCompleted) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('放弃本次练习？'),
                  content: const Text('随时可以再试，你不会失去什么。'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('继续'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                      },
                      child: const Text('放弃'),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            children: [
              // Technique name & mechanism
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: widget.technique.iconColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                ),
                child: Center(
                  child: Icon(
                    widget.technique.icon,
                    color: widget.technique.iconColor,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.technique.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(kColorAccent).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.technique.neuralMechanism,
                  style: const TextStyle(
                    color: Color(kColorAccent),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Timer circle
              if (!_isRunning && !_isCompleted) ...[
                Text(
                  '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Color(kColorPrimary),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '准备开始',
                  style: TextStyle(color: Color(kColorTextSecondary)),
                ),
              ] else if (!_isCompleted) ...[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Color(kColorSecondary).withAlpha(51),
                        valueColor: const AlwaysStoppedAnimation(Color(kColorSecondary)),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_remainingSeconds',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Color(kColorPrimary),
                          ),
                        ),
                        Text(
                          _isPaused ? '已暂停' : '进行中',
                          style: const TextStyle(color: Color(kColorTextSecondary)),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                const Icon(Icons.check_circle, color: Color(kColorAccent), size: 80),
                const SizedBox(height: 16),
                const Text(
                  '完成！',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(kColorAccent),
                  ),
                ),
              ],
              const SizedBox(height: 32),

              // Instruction card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(kColorBackground),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '操作步骤',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ...widget.technique.instruction.split('\n').map((line) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(line, style: const TextStyle(fontSize: 14)),
                    )),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              if (!_isRunning && !_isCompleted) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startTimer,
                    child: Text('开始 · ${widget.technique.durationSeconds}秒'),
                  ),
                ),
              ] else if (!_isCompleted) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isPaused ? _resumeTimer : _pauseTimer,
                        child: Text(_isPaused ? '继续' : '暂停'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onCompleted,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(kColorAccent),
                        ),
                        child: const Text('提前完成'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}