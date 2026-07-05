import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/tactile_card.dart';
import '../home_page.dart';

/// Onboarding Step 4: Day 1 Celebration
/// Full-screen confetti + Day 1 hero + "开始 Day 1" CTA
class CelebrationPage extends StatefulWidget {
  const CelebrationPage({super.key});

  @override
  State<CelebrationPage> createState() => _CelebrationPageState();
}

class _CelebrationPageState extends State<CelebrationPage>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confettiCtrl;
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _confettiCtrl =
        ConfettiController(duration: const Duration(seconds: 3));
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    Future.delayed(const Duration(milliseconds: 200), () {
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

  void _enter() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(kColorPrimary), Color(0xFF00B894), Color(kColorSecondary)],
          ),
        ),
        child: Stack(
          children: [
            // Confetti overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiCtrl,
                blastDirection: pi / 2,
                maxBlastForce: 20,
                minBlastForce: 8,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                gravity: 0.3,
                shouldLoop: false,
                colors: const [
                  Colors.white,
                  Color(0xFFFFC800),
                  Color(kColorWarning),
                  Color(0xFFFFFFFF),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(kPaddingLarge),
                child: Column(
                  children: [
                    const Spacer(),
                    ScaleTransition(
                      scale: _scale,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(60),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '🌱',
                            style: TextStyle(fontSize: 110),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _fade,
                      child: Column(
                        children: [
                          Text(
                            'Day 1',
                            style: GoogleFonts.nunito(
                              fontSize: 72,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -2,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '启程 ✦',
                            style: GoogleFonts.nunito(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withAlpha(220),
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(40),
                              borderRadius: BorderRadius.circular(kBorderRadiusPill),
                            ),
                            child: Text(
                              '你的大脑从今天开始重塑',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    FadeTransition(
                      opacity: _fade,
                      child: PressableCard(
                        backgroundColor: Colors.white,
                        borderColor: Colors.white,
                        onTap: _enter,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 22,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '进入清流',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: const Color(kColorPrimary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Color(kColorPrimary),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}