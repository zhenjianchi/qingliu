import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import 'goal_setup_page.dart';

/// Onboarding Step 2: Value Props Carousel
/// 3 swipeable cards: Urge 90s / Brain Recovery / Every Step Counts
class ValuePropsPage extends StatefulWidget {
  const ValuePropsPage({super.key});

  @override
  State<ValuePropsPage> createState() => _ValuePropsPageState();
}

class _ValuePropsPageState extends State<ValuePropsPage> {
  final _ctrl = PageController();
  int _page = 0;

  final _props = const [
    _ValueProp(
      emoji: '⏱️',
      title: '每个渴望都能用 90 秒度过',
      desc: '你的大脑奖赏系统会随每一次浪潮重新校准',
      color: Color(kColorPrimary),
    ),
    _ValueProp(
      emoji: '🧠',
      title: '你的大脑每天都在恢复',
      desc: '神经通路每天重建 - 你比自己想象的更强',
      color: Color(kColorSecondary),
    ),
    _ValueProp(
      emoji: '🏆',
      title: '你已经走过的每一步，都算数',
      desc: '你的进步是永久的 - 永远不会被遗忘',
      color: Color(0xFFFF8C42),
    ),
  ];

  void _next() {
    if (_page < _props.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const GoalSetupPage(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        ),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const GoalSetupPage(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top skip bar
            Padding(
              padding: const EdgeInsets.all(kPaddingMedium),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  const Spacer(),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      '跳过',
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(kColorTextHint),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _props.length,
                itemBuilder: (context, i) {
                  final p = _props[i];
                  return Padding(
                    padding: const EdgeInsets.all(kPaddingLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: p.color.withAlpha(30),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: p.color.withAlpha(102),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              p.emoji,
                              style: const TextStyle(fontSize: 110),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          p.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          p.desc,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(kColorTextSecondary),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots + CTA
            Padding(
              padding: const EdgeInsets.all(kPaddingLarge),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_props.length, (i) {
                      final isActive = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 32 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(kColorPrimary)
                              : const Color(kColorPrimary).withAlpha(60),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(kColorPrimary),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                      ),
                      child: Text(
                        _page == _props.length - 1 ? '下一步' : '继续',
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueProp {
  final String emoji;
  final String title;
  final String desc;
  final Color color;

  const _ValueProp({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.color,
  });
}