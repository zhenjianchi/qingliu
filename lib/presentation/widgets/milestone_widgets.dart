import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class MilestoneCelebrationDialog extends StatefulWidget {
  final int milestoneDays;
  final String milestoneName;
  final String emoji;
  final String neuralDescription;
  final VoidCallback onComplete;

  const MilestoneCelebrationDialog({
    super.key,
    required this.milestoneDays,
    required this.milestoneName,
    required this.emoji,
    required this.neuralDescription,
    required this.onComplete,
  });

  @override
  State<MilestoneCelebrationDialog> createState() => _MilestoneCelebrationDialogState();
}

class _MilestoneCelebrationDialogState extends State<MilestoneCelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _emojiController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _emojiAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _emojiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _emojiAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _emojiController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController.forward();
    _emojiController.forward();
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _emojiController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kBorderRadiusXLarge),
            boxShadow: [
              BoxShadow(
                color: const Color(kColorPrimary).withAlpha(77),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  AnimatedBuilder(
                    animation: _confettiController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(200, 100),
                        painter: _ConfettiPainter(
                          progress: _confettiController.value,
                          colors: const [
                            Color(kColorPrimary),
                            Color(kColorSecondary),
                            Color(kColorAccent),
                            Color(0xFFFFD700),
                          ],
                        ),
                      );
                    },
                  ),
                  ScaleTransition(
                    scale: _emojiAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(kColorPrimary),
                            Color(kColorSecondary),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(kColorPrimary).withAlpha(128),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.emoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '${widget.milestoneDays}天',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w200,
                  color: Color(kColorPrimary),
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(kColorAccent), Color(kColorAccentDark)],
                  ),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: Text(
                  widget.milestoneName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(kColorSecondary).withAlpha(26),
                  borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.science_outlined,
                      color: Color(kColorSecondary),
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.neuralDescription,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(kColorTextSecondary),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '你值得为自己骄傲 🌟',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(kColorTextHint),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onComplete,
                  child: const Text('继续前行'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  _ConfettiPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 2 * math.pi + (progress * math.pi);
      final distance = 40 + random.nextDouble() * 40 + (progress * 30);
      final x = center.dx + math.cos(angle) * distance;
      final y = center.dy + math.sin(angle) * distance - (progress * 20);

      final paint = Paint()
        ..color = colors[i % colors.length].withAlpha(
          ((1 - progress) * 255).toInt().clamp(0, 255),
        )
        ..style = PaintingStyle.fill;

      final confettiSize = 4.0 + random.nextDouble() * 4;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + progress * math.pi);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: confettiSize, height: confettiSize / 2),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class BouncyIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const BouncyIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
  });

  @override
  State<BouncyIcon> createState() => _BouncyIconState();
}

class _BouncyIconState extends State<BouncyIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        );
      },
    );
  }
}