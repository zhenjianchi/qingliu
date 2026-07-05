import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/abstinence_bloc.dart';
import 'urge_panel_page.dart';
import 'progress_page.dart';
import 'trigger_log_page.dart';
import 'ai_support_page.dart';
import 'settings_page.dart';

/// V3.0 Home Page (iOS-style)
/// 参考: doc/design/20260705/HTML/mobile-ios.html (Screen 01)
///
/// - Greeting header (date + "早安，小宇")
/// - Dark hero card with day counter
/// - 2x2 quick action grid
/// - Today's stats (flat cards)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '朋友';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(kStorageUserName);
    if (!mounted) return;
    if (name != null && name.isNotEmpty) {
      setState(() => _userName = name);
    }
  }

  String _formatDate() {
    final now = DateTime.now();
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return '${weekdays[now.weekday - 1]} · ${now.month}月${now.day}';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '夜深了';
    if (hour < 11) return '早安';
    if (hour < 13) return '中午好';
    if (hour < 18) return '下午好';
    if (hour < 22) return '晚上好';
    return '夜深了';
  }

  String _formatElapsed(Duration d) {
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final mins = d.inMinutes.remainder(60);
    final secs = d.inSeconds.remainder(60);
    return '${days}天 ${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getWeekLabel(int days) {
    return '第 ${(days / 7).floor() + 1} 周';
  }

  String _getNeuralMessage(int days) {
    if (days < 1) return '启程 · 你的大脑开始重新校准';
    if (days < 7) return '多巴胺受体开始适应非人工刺激的节奏';
    if (days < 14) return '前额叶功能持续改善中';
    if (days < 30) return '突触连接重塑中 · 你的意志力在增强';
    if (days < 60) return '神经递质水平初步恢复基线';
    return '多巴胺受体密度增加 · 你的神经系统正在重塑';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: BlocConsumer<AbstinenceBloc, AbstinenceState>(
        listener: (context, state) {
          if (state is AbstinenceJustRelapsed) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TriggerLogPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AbstinenceActive) {
            return _buildActiveView(context, state);
          }
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Color(kColorPrimary),
                strokeWidth: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActiveView(BuildContext context, AbstinenceActive state) {
    final days = state.elapsed.inDays;
    final progress = (days / state.record.goalDays).clamp(0.0, 1.0);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 18),

            // Hero card (dark)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildHeroCard(context, state, days, progress),
            ),

            const SizedBox(height: 22),

            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '你今天可以做什么',
                    style: AppTheme.monoLabel(
                      color: const Color(kColorTextHint),
                      fontSize: 11,
                    ).copyWith(letterSpacing: 0.16),
                  ),
                  const SizedBox(height: 10),
                  _buildQuickActionsGrid(context),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Today's stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今天',
                    style: AppTheme.monoLabel(
                      color: const Color(kColorTextHint),
                      fontSize: 11,
                    ).copyWith(letterSpacing: 0.16),
                  ),
                  const SizedBox(height: 10),
                  _buildTodayStats(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(),
                  style: AppTheme.monoLabel(
                    color: const Color(kColorTextHint),
                    fontSize: 11,
                  ).copyWith(letterSpacing: 0.16),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getGreeting()}，$_userName',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(kColorTextPrimary),
                    height: 1.2,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          _buildIconButton(
            icon: Icons.settings_outlined,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(kColorSurface),
            border: Border.all(color: const Color(kColorBorder)),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: const Color(kColorTextPrimary)),
        ),
      ),
    );
  }

  Widget _buildHeroCard(
    BuildContext context,
    AbstinenceActive state,
    int days,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: const Color(kColorTextPrimary),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '第 $days 天 · 神经恢复进行中',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withAlpha(153),
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _formatElapsed(state.elapsed),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.0,
              letterSpacing: -1,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withAlpha(31),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$days / ${state.record.goalDays}',
                style: AppTheme.tabularNum(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(140),
                ),
              ),
              Text(
                _getWeekLabel(days),
                style: AppTheme.tabularNum(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withAlpha(140),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '第 $days 天。你还在。这就够了。',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withAlpha(200),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: [
        _quickCard(
          context,
          icon: Icons.bolt,
          label: '渴望应对',
          hint: '从此刻到应对 ≤ 3 秒',
          onTap: () => _openUrge(context),
        ),
        _quickCard(
          context,
          icon: Icons.chat_bubble_outline,
          label: 'AI 即时支持',
          hint: '按你的情境说话',
          onTap: () => _openAi(context),
        ),
        _quickCard(
          context,
          icon: Icons.show_chart,
          label: '进展',
          hint: '本周 + 全部',
          onTap: () => _openProgress(context),
        ),
        _quickCard(
          context,
          icon: Icons.bookmark_outline,
          label: '记录触发',
          hint: '留下此刻的线索',
          onTap: () => _openTrigger(context),
        ),
      ],
    );
  }

  Widget _quickCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(kColorSurface),
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
            border: Border.all(color: const Color(kColorBorderSoft)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(kColorPrimary).withAlpha(36),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(kColorPrimary),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(kColorTextPrimary),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(kColorTextHint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayStats(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: const Color(kColorBorderSoft)),
      ),
      child: Column(
        children: [
          _statRow('早晨承诺', '已完成', isPill: true),
          const Divider(height: 1, color: Color(kColorBorderSoft)),
          _statRow('成功应对', '1 次'),
          const Divider(height: 1, color: Color(kColorBorderSoft)),
          _statRow('触发记录', '1 次'),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, {bool isPill = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(kColorTextPrimary),
            ),
          ),
          if (isPill)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(kColorTextMeta).withAlpha(51),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(kColorTextSecondary),
                ),
              ),
            )
          else
            Text(
              value,
              style: AppTheme.tabularNum(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(kColorTextPrimary),
              ),
            ),
        ],
      ),
    );
  }

  void _openUrge(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UrgePanelPage()),
    );
  }

  void _openAi(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AiSupportPage()),
    );
  }

  void _openProgress(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ProgressPage()),
    );
  }

  void _openTrigger(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TriggerLogPage()),
    );
  }
}