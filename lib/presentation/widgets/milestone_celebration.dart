import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/tactile_card.dart';

/// MilestoneCelebration - Full-screen celebration overlay
/// Shows when user hits a milestone day (7, 14, 30, 60, 90, 180, 365)
class MilestoneCelebration extends StatefulWidget {
  final int days;
  final VoidCallback onClose;

  const MilestoneCelebration({
    super.key,
    required this.days,
    required this.onClose,
  });

  @override
  State<MilestoneCelebration> createState() => _MilestoneCelebrationState();
}

class _MilestoneCelebrationState extends State<MilestoneCelebration>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confettiCtrl;
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(
      duration: const Duration(seconds: 4),
    );
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _ctrl.forward();
        _confettiCtrl.play();
      }
    });
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final milestone = _getMilestoneData(widget.days);
    return Material(
      color: Colors.black.withAlpha(204),
      child: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiCtrl,
              blastDirection: pi / 2,
              maxBlastForce: 25,
              minBlastForce: 10,
              emissionFrequency: 0.04,
              numberOfParticles: 35,
              gravity: 0.25,
              shouldLoop: false,
              colors: const [
                Color(kColorPrimary),
                Color(kColorSecondary),
                Color(kColorWarning),
                Color(0xFFFF8C42),
                Colors.white,
              ],
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: Padding(
                padding: const EdgeInsets.all(kPaddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scale,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              milestone.color,
                              milestone.color.withAlpha(180),
                            ],
                          ),
                          border: Border.all(color: Colors.white, width: 5),
                          boxShadow: [
                            BoxShadow(
                              color: milestone.color.withAlpha(102),
                              blurRadius: 30,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            milestone.emoji,
                            style: const TextStyle(fontSize: 100),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'DAY ${widget.days}',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withAlpha(204),
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      milestone.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(kBorderRadiusPill),
                      ),
                      child: Text(
                        milestone.message,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    PressableCard(
                      backgroundColor: Colors.white,
                      borderColor: Colors.white,
                      onTap: widget.onClose,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 18,
                      ),
                      child: Text(
                        '继续前进',
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: milestone.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: widget.onClose,
                      child: Text(
                        '查看成就',
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withAlpha(180),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _MilestoneData _getMilestoneData(int days) {
    switch (days) {
      case 7:
        return _MilestoneData(
          name: '初绽',
          emoji: '🌱',
          color: const Color(kColorPrimary),
          message: '一周坚持 - 你比自己想象的更强',
        );
      case 14:
        return _MilestoneData(
          name: '嫩芽',
          emoji: '🌿',
          color: const Color(0xFF7BE325),
          message: '两周蜕变 - 新的神经通路正在形成',
        );
      case 30:
        return _MilestoneData(
          name: '破土',
          emoji: '🌸',
          color: const Color(kColorSecondary),
          message: '一个月 - 这是真正的里程碑',
        );
      case 60:
        return _MilestoneData(
          name: '向阳',
          emoji: '🌻',
          color: const Color(0xFFFFC800),
          message: '60 天 - 你的大脑已经重塑',
        );
      case 90:
        return _MilestoneData(
          name: '盛放',
          emoji: '🏵️',
          color: const Color(0xFFFF8C42),
          message: '90 天 - 多巴胺系统完全恢复',
        );
      case 180:
        return _MilestoneData(
          name: '硕果',
          emoji: '🌺',
          color: const Color(0xFFCE82FF),
          message: '半年 - 你已经是真正的胜利者',
        );
      case 365:
        return _MilestoneData(
          name: '传奇',
          emoji: '🌳',
          color: const Color(0xFFFF4B4B),
          message: '一年 - 你改变了自己的人生',
        );
      default:
        return _MilestoneData(
          name: '继续',
          emoji: '⭐',
          color: const Color(kColorPrimary),
          message: '每天都在变强',
        );
    }
  }
}

class _MilestoneData {
  final String name;
  final String emoji;
  final Color color;
  final String message;

  _MilestoneData({
    required this.name,
    required this.emoji,
    required this.color,
    required this.message,
  });
}