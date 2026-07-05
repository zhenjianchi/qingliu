import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/abstinence_bloc.dart';
import 'onboarding_page.dart';

/// V3.0 Splash Page
/// 参考: doc/design/20260705/HTML/mobile-splash.html
///
/// - Big glyph "清" in breathing circle
/// - "清流" wordmark
/// - "陪你慢慢来。" tagline
/// - Primary: 开始新的 (default 90 days)
/// - Secondary: 继续 (only if existing record)
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: _SplashBrand()),
            _SplashBottom(),
          ],
        ),
      ),
    );
  }
}

class _SplashBrand extends StatefulWidget {
  const _SplashBrand();

  @override
  State<_SplashBrand> createState() => _SplashBrandState();
}

class _SplashBrandState extends State<_SplashBrand>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _shadow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _shadow = Tween(begin: 16.0, end: 20.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              return Container(
                width: 124,
                height: 124,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(kColorSurfaceWarm),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x448B6B46),
                      blurRadius: _shadow.value,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(_scale.value),
                child: Text(
                  '清',
                  style: GoogleFonts.inter(
                    fontSize: 64,
                    fontWeight: FontWeight.w500,
                    color: const Color(kColorTextPrimary),
                    height: 1.0,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            '清流',
            style: AppTheme.tabularNum(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: const Color(kColorTextPrimary),
            ).copyWith(letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          Text(
            '陪你慢慢来。',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(kColorTextSecondary),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'V1.0 · 本产品不替代专业心理咨询',
            style: AppTheme.monoLabel(
              color: const Color(kColorTextMeta),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbstinenceBloc, AbstinenceState>(
      builder: (context, state) {
        final hasRecord = state is AbstinenceActive;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            children: [
              if (!hasRecord)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _startNew(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(kColorPrimary),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusPill),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('开始新的 90 天'),
                  ),
                )
              else
                _buildResumeButton(context, state),
              const SizedBox(height: 8),
              if (hasRecord)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => _startNew(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(kColorTextPrimary),
                      minimumSize: const Size(double.infinity, 48),
                      textStyle: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('重新开始'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResumeButton(BuildContext context, AbstinenceActive state) {
    final days = state.elapsed.inDays;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _resume(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(kColorPrimary),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusPill),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text('继续 · 第 $days 天'),
      ),
    );
  }

  void _startNew(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const OnboardingPage()),
    );
  }

  void _resume(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}