import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/log/app_logger.dart';
import '../../blocs/abstinence_bloc.dart';
import 'celebration_page.dart';

/// Onboarding Step 3: Goal Setup
/// User picks duration: 7/14/30/60/90/100/180 days + optional declaration
class GoalSetupPage extends StatefulWidget {
  const GoalSetupPage({super.key});

  @override
  State<GoalSetupPage> createState() => _GoalSetupPageState();
}

class _GoalSetupPageState extends State<GoalSetupPage> {
  final _logger = AppLogger.instance;
  int _selectedDays = 30;
  final _declarationController = TextEditingController();
  final _goalOptions = const [7, 14, 30, 60, 90, 100, 180];

  Future<void> _start() async {
    final declaration = _declarationController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_declaration', declaration);
    await prefs.setInt('user_goal_days', _selectedDays);
    await prefs.setBool('onboarding_complete', true);

    _logger.info('Onboarding complete: $_selectedDays days', tag: 'Onboarding');

    if (!mounted) return;

    // Start the abstinence record via BLoC
    context
        .read<AbstinenceBloc>()
        .add(AbstinenceStarted(goalDays: _selectedDays));

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const CelebrationPage(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _declarationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    color: const Color(kColorTextHint),
                  ),
                  const Spacer(),
                  Text(
                    '3 / 4',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(kColorTextHint),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const SizedBox(
                    width: 24,
                    child: LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Color(kColorPrimaryLight),
                      valueColor: AlwaysStoppedAnimation(Color(kColorPrimary)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '选择你的目标',
                style: GoogleFonts.nunito(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '你可以随时调整',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(kColorTextSecondary),
                ),
              ),
              const SizedBox(height: 32),

              // Goal grid
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _goalOptions.length,
                  itemBuilder: (context, i) {
                    final days = _goalOptions[i];
                    final selected = days == _selectedDays;
                    final isPopular = days == 30;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDays = days),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(kColorPrimary)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          border: Border.all(
                            color: selected
                                ? const Color(kColorPrimary)
                                : const Color(0xFFEAEAEA),
                            width: 2,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: const Color(kColorPrimary)
                                        .withAlpha(102),
                                    blurRadius: 0,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          children: [
                            if (isPopular && !selected)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(kColorWarning),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '推荐',
                                    style: GoogleFonts.nunito(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$days',
                                    style: GoogleFonts.nunito(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: selected
                                          ? Colors.white
                                          : const Color(kColorPrimary),
                                    ),
                                  ),
                                  Text(
                                    '天',
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: selected
                                          ? Colors.white
                                          : const Color(kColorTextSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Declaration input
              Text(
                '你的戒断宣言（可选）',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: const Color(kColorTextSecondary),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _declarationController,
                maxLines: 2,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: '例：今天我选择给前额叶一个机会',
                  hintStyle: GoogleFonts.nunito(
                    color: const Color(kColorTextHint),
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    borderSide: const BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    borderSide: const BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    borderSide: const BorderSide(
                        color: Color(kColorPrimary), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _start,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(kColorPrimary),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '启程 Day 1',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 22),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}