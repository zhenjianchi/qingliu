import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/log/app_logger.dart';
import '../../blocs/abstinence_bloc.dart';

/// V3.0 Onboarding - 3 steps
/// 参考: doc/design/20260705/HTML/mobile-onboarding.html
///
/// Step 1: 清流不会催你做任何事。
/// Step 2: 你的神经系统正在慢慢习惯一种新的安静。
/// Step 3: 当你渴望来袭，我们准备好了。
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _ctrl = PageController();
  int _page = 0;
  final _logger = AppLogger.instance;

  final _steps = const [
    _OnboardingStep(
      number: '01',
      title: '清流不会催你做任何事。',
      body: '在这里，破戒不是失败 —— 它只是还没写完的笔记。我们陪你从每一次跌倒里找到下一个微调。停下来、慢一点、走哪都行。',
      illustration: _IllustWelcome(),
    ),
    _OnboardingStep(
      number: '02',
      title: '你的神经系统正在慢慢习惯一种新的安静。',
      body: '神经科学告诉我们：每多撑过一天，前额叶就多学会一点从噪音里挑出真正重要的信号。这不是玄学，是多巴胺受体的恢复 —— 通常需要约 90 天。',
      illustration: _IllustNeural(),
    ),
    _OnboardingStep(
      number: '03',
      title: '当你渴望来袭，我们准备好了。',
      body: '11 种循证技术 · 3 秒可达 · 全部本地处理。其中 T4（90 秒呼吸法）和 T5（感官接地）是神经科学验证的优先选择 —— 我们会先给你这两个。',
      illustration: _IllustTools(),
    ),
  ];

  void _next() async {
    if (_page < _steps.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    } else {
      // Complete onboarding
      await _completeOnboarding();
    }
  }

  void _prev() {
    if (_page > 0) {
      _ctrl.previousPage(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    _logger.info('Onboarding complete (V3.0 3-step)', tag: 'Onboarding');

    if (!mounted) return;
    context.read<AbstinenceBloc>().add(AbstinenceStarted(goalDays: 90));
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar mimic
            const SizedBox(height: 8),

            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _steps.length,
                itemBuilder: (context, i) => _OnboardingStepView(step: _steps[i]),
              ),
            ),

            // Footer with dots + actions
            _OnboardingFooter(
              page: _page,
              total: _steps.length,
              onBack: _prev,
              onNext: _next,
              isLast: _page == _steps.length - 1,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final String number;
  final String title;
  final String body;
  final Widget illustration;

  const _OnboardingStep({
    required this.number,
    required this.title,
    required this.body,
    required this.illustration,
  });
}

class _OnboardingStepView extends StatelessWidget {
  final _OnboardingStep step;

  const _OnboardingStepView({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 1),
          // Eyebrow
          Text(
            'STEP ${step.number} OF 03',
            style: AppTheme.monoLabel(
              color: const Color(kColorTextHint),
              fontSize: 11,
            ).copyWith(letterSpacing: 0.16),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            step.title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(kColorTextPrimary),
              height: 1.25,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 14),
          // Body
          Text(
            step.body,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(kColorTextSecondary),
              height: 1.6,
            ),
          ),
          const Spacer(flex: 1),
          // Illustration
          SizedBox(
            height: 200,
            child: Center(child: step.illustration),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  final int page;
  final int total;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final bool isLast;

  const _OnboardingFooter({
    required this.page,
    required this.total,
    required this.onBack,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(total, (i) {
              final active = i == page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(kColorPrimary)
                      : const Color(kColorBorder),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          // Actions
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onBack,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(kColorTextHint),
                    minimumSize: const Size(double.infinity, 48),
                    textStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text(page == 0 ? '跳过' : '← 上一步'),
                ),
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(kColorPrimary),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(isLast ? '开始计时 →' : '继续 →'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Illustrations ────────────────────────────────────────────

class _IllustWelcome extends StatelessWidget {
  const _IllustWelcome();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(kColorSurfaceWarm),
        border: Border.all(color: const Color(kColorBorderSoft), width: 1),
      ),
      child: CustomPaint(painter: _WelcomeIllustPainter()),
    );
  }
}

class _WelcomeIllustPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final paint = Paint()
      ..color = const Color(kColorTextMeta)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Outer dashed circle
    canvas.drawCircle(c, size.width * 0.32, paint);

    // Inner cross
    canvas.drawLine(Offset(c.dx, c.dy - 22), Offset(c.dx, c.dy + 22), paint);
    canvas.drawLine(Offset(c.dx - 22, c.dy), Offset(c.dx + 22, c.dy), paint);

    // Diagonals
    canvas.drawLine(Offset(c.dx - 16, c.dy - 16),
        Offset(c.dx + 16, c.dy + 16), paint);
    canvas.drawLine(Offset(c.dx + 16, c.dy - 16),
        Offset(c.dx - 16, c.dy + 16), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IllustNeural extends StatelessWidget {
  const _IllustNeural();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      child: CustomPaint(painter: _NeuralIllustPainter()),
    );
  }
}

class _NeuralIllustPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final strokePaint = Paint()
      ..color = const Color(kColorTextMeta)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = const Color(kColorPrimary)
      ..style = PaintingStyle.fill;

    final positions = [
      Offset(c.dx - 40, c.dy), // left
      Offset(c.dx, c.dy - 28), // top
      Offset(c.dx, c.dy + 28), // bottom
      Offset(c.dx + 40, c.dy), // right
      Offset(c.dx, c.dy),       // center
    ];

    // Draw nodes
    for (final pos in positions) {
      canvas.drawCircle(pos, 5, fillPaint);
    }

    // Draw connections (dashed)
    final dashPaint = Paint()
      ..color = const Color(kColorBorder)
      ..strokeWidth = 1;

    void drawDash(Offset from, Offset to) {
      final path = Path()..moveTo(from.dx, from.dy)..lineTo(to.dx, to.dy);
      canvas.drawPath(
        _dashPath(path, 3, 4),
        dashPaint,
      );
    }

    drawDash(positions[0], positions[1]);
    drawDash(positions[0], positions[2]);
    drawDash(positions[1], positions[3]);
    drawDash(positions[2], positions[3]);
    drawDash(positions[0], positions[4]);
    drawDash(positions[1], positions[4]);
    drawDash(positions[2], positions[4]);
    drawDash(positions[3], positions[4]);
  }

  Path _dashPath(Path source, double dash, double gap) {
    final result = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        result.addPath(
          metric.extractPath(distance, distance + dash),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IllustTools extends StatelessWidget {
  const _IllustTools();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _chip(Icons.air, 'T4 呼吸'),
            const SizedBox(width: 8),
            _chip(Icons.visibility, 'T5 接地'),
            const SizedBox(width: 8),
            _chip(Icons.water_drop, 'T11 冷水'),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'T4 · T5 · T11',
          style: AppTheme.monoLabel(
            color: const Color(kColorTextHint),
            fontSize: 11,
          ).copyWith(letterSpacing: 0.1),
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(kColorSurface),
        border: Border.all(color: const Color(kColorBorderSoft)),
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(kColorPrimary), size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(kColorTextSecondary),
            ),
          ),
        ],
      ),
    );
  }
}