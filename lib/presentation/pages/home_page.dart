import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/user_level.dart';
import '../../domain/services/achievement_service.dart';
import '../blocs/abstinence_bloc.dart';
import '../widgets/atoms.dart';
import '../widgets/day_wall.dart';
import '../widgets/tactile_card.dart';
import 'urge_panel_page.dart';
import 'relapse_support_page.dart';

/// V2.0 HomePage - Lingo Design System
///
/// Hero number + brain recovery + daily ritual + DayWall + achievements + level
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // Demo achievements (in real app, would come from repository)
  late List<Achievement> _achievements;
  // Demo XP
  final int _userXP = 1240;

  @override
  void initState() {
    super.initState();
    _achievements = AchievementService.getAllAchievements();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AbstinenceBloc, AbstinenceState>(
        listener: (context, state) {
          if (state is AbstinenceJustRelapsed) {
            _showRelapsePage(context, state);
          }
        },
        builder: (context, state) {
          if (state is AbstinenceLoading || state is AbstinenceInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(kColorPrimary)),
            );
          }
          if (state is AbstinenceNoRecord) return _buildNoRecordView(context);
          if (state is AbstinenceActive) return _buildActiveView(context, state);
          if (state is AbstinenceError) {
            return Center(child: Text('错误: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: const _UrgeFab(),
    );
  }

  Widget _buildNoRecordView(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(kColorPrimary), Color(kColorSecondary)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text('🌊', style: TextStyle(fontSize: 96)),
                const SizedBox(height: 24),
                Text(
                  '你不是一个人在战斗',
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '科学戒色，从这里开始',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withAlpha(220),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                TactileCard(
                  backgroundColor: Colors.white,
                  borderColor: Colors.white,
                  onTap: () => context
                      .read<AbstinenceBloc>()
                      .add(AbstinenceStarted(goalDays: 30)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  child: Text(
                    '开始 30 天挑战',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(kColorPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _showGoalPicker(context),
                  child: Text(
                    '自定义时长',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGoalPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '选择你的目标',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              for (final days in [7, 14, 30, 60, 90, 100, 180])
                ListTile(
                  title: Text('$days 天挑战',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(ctx);
                    context
                        .read<AbstinenceBloc>()
                        .add(AbstinenceStarted(goalDays: days));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveView(BuildContext context, AbstinenceActive state) {
    final days = state.elapsed.inDays;
    final milestoneEmoji = _getMilestoneEmoji(days);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          kPaddingLarge,
          kPaddingMedium,
          kPaddingLarge,
          100, // FAB padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top status bar
            Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(
                  '$days 天 · 大脑觉醒中 $milestoneEmoji',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Hero number
            Center(
              child: StepCounter(
                number: '$days',
                label: 'DAYS STRONG',
                color: const Color(kColorPrimary),
              ),
            ),
            const SizedBox(height: 24),

            // Brain recovery narrative
            TactileCard(
              borderColor: const Color(kColorSecondary),
              child: Row(
                children: [
                  const Text('🧠', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '你的大脑正在恢复',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getBrainRecoveryMessage(days),
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily ritual section
            _buildSectionHeader(context, '☀️ 今日仪式', '3 分钟内完成'),
            const SizedBox(height: 12),
            _buildRitualCards(context),
            const SizedBox(height: 24),

            // Day wall
            _buildSectionHeader(context, '📅 心情时间墙', '点击格子查看详情'),
            const SizedBox(height: 12),
            _buildDayWallSection(context),
            const SizedBox(height: 24),

            // Recent achievements
            _buildSectionHeader(context, '🏆 最近成就', '共 ${_achievements.where((a) => a.unlocked).length} / ${_achievements.length}'),
            const SizedBox(height: 12),
            _buildAchievementsRow(context),
            const SizedBox(height: 24),

            // Level/XP
            _buildLevelSection(context, _userXP),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(kColorTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildRitualCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TactileCard(
            borderColor: const Color(kColorWarning),
            onTap: () => _showSnackBar(context, '早晨承诺功能开发中'),
            padding: const EdgeInsets.all(kPaddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('☀️', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  '早晨承诺',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '< 10 秒',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(kColorTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TactileCard(
            borderColor: const Color(kColorSecondary),
            onTap: () => _showSnackBar(context, '傍晚回顾功能开发中'),
            padding: const EdgeInsets.all(kPaddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🌙', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  '傍晚回顾',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '< 2 分钟',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(kColorTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayWallSection(BuildContext context) {
    final entries = List.generate(
      30,
      (i) => DayEntry(
        date: DateTime.now().subtract(Duration(days: 29 - i)),
        moodLevel: ((i * 7) % 5) + 1,
        hasRecord: i > 5,
      ),
    );
    return TactileCard(
      child: DayWall(entries: entries),
    );
  }

  Widget _buildAchievementsRow(BuildContext context) {
    final unlocked = _achievements.where((a) => a.unlocked).take(3).toList();
    final demoUnlocks = <Achievement>[
      _achievements.firstWhere((a) => a.id == 'day_1'),
      _achievements.firstWhere((a) => a.id == 'day_7'),
      _achievements.firstWhere((a) => a.id == 'first_response'),
    ];
    final displayList = unlocked.isEmpty ? demoUnlocks : unlocked;

    return Row(
      children: [
        for (int i = 0; i < displayList.length; i++) ...[
          Expanded(child: _buildAchievementBadge(displayList[i])),
          if (i < displayList.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }

  Widget _buildAchievementBadge(Achievement achievement) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.color.withAlpha(30),
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: achievement.color, width: 2),
      ),
      child: Column(
        children: [
          Icon(achievement.icon, color: achievement.color, size: 32),
          const SizedBox(height: 6),
          Text(
            achievement.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunito(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: achievement.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSection(BuildContext context, int xp) {
    final userLevel = UserLevel.fromXP(xp);
    return TactileCard(
      borderColor: const Color(kColorPrimary),
      child: Row(
        children: [
          LevelBadge(level: userLevel.level),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lv ${userLevel.level} · ${userLevel.title}',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                XpBar(
                  currentXP: userLevel.currentXP,
                  nextLevelXP: userLevel.nextLevelXP,
                  levelTitle: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMilestoneEmoji(int days) {
    if (days < 7) return '🌱';
    if (days < 14) return '🌿';
    if (days < 30) return '🌸';
    if (days < 60) return '🌻';
    if (days < 90) return '🏵️';
    if (days < 180) return '🌺';
    return '🌳';
  }

  String _getBrainRecoveryMessage(int days) {
    if (days < 1) return '启程 - 你的大脑开始重新校准';
    if (days < 7) return '多巴胺受体开始适应非人工刺激的节奏';
    if (days < 14) return '前额叶功能持续改善 - 自控力正在恢复';
    if (days < 30) return '突触连接重塑中 - 你的意志力在增强';
    if (days < 90) return '深层神经通路已经重新校准';
    return '你的大脑已建立新的奖赏回路';
  }

  void _showRelapsePage(BuildContext context, AbstinenceJustRelapsed state) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RelapseSupportPage(
          previousRecord: state.previousRecord,
          previousDays: state.previousDays,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
      ),
    );
  }
}

class _UrgeFab extends StatefulWidget {
  const _UrgeFab();

  @override
  State<_UrgeFab> createState() => _UrgeFabState();
}

class _UrgeFabState extends State<_UrgeFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 1.06).animate(
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
    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<AbstinenceBloc>(),
              child: const UrgePanelPage(),
            ),
          ),
        ),
        backgroundColor: const Color(kColorPrimary),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.bolt, size: 24),
        label: Text(
          '渴望',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}