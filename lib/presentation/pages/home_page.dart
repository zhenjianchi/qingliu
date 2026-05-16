import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/abstinence_bloc.dart';
import '../widgets/common_widgets.dart';
import 'urge_panel_page.dart';
import 'trigger_log_page.dart';
import 'relapse_support_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AbstinenceBloc, AbstinenceState>(
        listener: (context, state) {
          if (state is AbstinenceJustRelapsed) {
            _showRelapseDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state is AbstinenceLoading || state is AbstinenceInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(kColorPrimary),
              ),
            );
          }

          if (state is AbstinenceNoRecord) {
            return _buildNoRecordView(context);
          }

          if (state is AbstinenceActive) {
            return _buildActiveView(context, state);
          }

          if (state is AbstinenceError) {
            return Center(
              child: Text('错误: ${state.message}'),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNoRecordView(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9F9),
              Color(kColorBackground),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(kColorPrimary), Color(kColorSecondary)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(kColorPrimary).withAlpha(77),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.water_drop_outlined,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  '清流',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: const Color(kColorPrimary),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '用科学的方式，陪你建立健康习惯',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                _buildGoalSelector(context),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _startAbstinence(context, 30),
                    child: const Text('开始30天挑战'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _startAbstinence(context, 90),
                  child: const Text('进阶90天挑战'),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalSelector(BuildContext context) {
    return Column(
      children: [
        Text(
          '选择你的目标',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [7, 14, 30, 60, 90].map((days) {
            final isSelected = false;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: OutlinedButton(
                onPressed: () => _startAbstinence(context, days),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? const Color(kColorPrimary).withAlpha(26)
                      : Colors.transparent,
                  side: BorderSide(
                    color: const Color(kColorPrimary).withAlpha(128),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text('$days 天'),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _startAbstinence(BuildContext context, int days) {
    context.read<AbstinenceBloc>().add(AbstinenceStarted(goalDays: days));
  }

  Widget _buildActiveView(BuildContext context, AbstinenceActive state) {
    final days = state.elapsed.inDays;
    final hours = state.elapsed.inHours % 24;
    final minutes = state.elapsed.inMinutes % 60;
    final progress = (days / state.record.goalDays).clamp(0.0, 1.0);
    final weekNumber = (days ~/ 7) + 1;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF9F9),
              Color(kColorBackground),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildHeader(context, weekNumber),
                const SizedBox(height: 32),
                _buildProgressRing(context, days, hours, minutes, progress),
                const SizedBox(height: 24),
                _buildNeuralRecoveryCard(days),
                const SizedBox(height: 24),
                _buildStatsRow(context, state, days, progress),
                const SizedBox(height: 32),
                _buildUrgeButton(context),
                const SizedBox(height: 16),
                _buildQuickActions(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int weekNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '第 $weekNumber 周',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const BreathingIndicator(color: Color(kColorAccent)),
                const SizedBox(width: 8),
                Text(
                  '恢复进行中',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(kColorAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius),
            boxShadow: [
              BoxShadow(
                color: const Color(kShadowColor),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline,
            color: Color(kColorTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRing(
    BuildContext context,
    int days,
    int hours,
    int minutes,
    double progress,
  ) {
    return Center(
      child: AnimatedProgressRing(
        progress: progress,
        size: 220,
        strokeWidth: 16,
        progressColor: const Color(kColorPrimary),
        backgroundColor: const Color(kColorPrimary).withAlpha(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$days',
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w200,
                color: Color(kColorTextPrimary),
                height: 1,
              ),
            ),
            Text(
              '天',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(kColorTextSecondary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${hours}时${minutes}分',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeuralRecoveryCard(int days) {
    String? neuralDesc;
    int? nearestKey;
    for (var entry in kNeuralRecoveryDescriptions.entries) {
      if (days >= entry.key) {
        neuralDesc = entry.value;
        nearestKey = entry.key;
      }
    }
    if (neuralDesc == null) return const SizedBox.shrink();

    final nextKeys = kNeuralRecoveryDescriptions.keys.where((k) => k > nearestKey!).toList();
    final nextMilestone = nextKeys.isNotEmpty ? nextKeys.first : nearestKey!;
    final rangeSize = nextMilestone - nearestKey!;
    final progress = rangeSize > 0
        ? ((days - nearestKey!) / rangeSize).clamp(0.0, 1.0)
        : 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: const Color(kColorSecondary).withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(kColorSecondary).withAlpha(26),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: const Icon(
                  Icons.science_outlined,
                  color: Color(kColorSecondary),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '神经恢复进程',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(kColorTextPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            neuralDesc,
            style: const TextStyle(
              fontSize: 13,
              color: Color(kColorTextSecondary),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(kColorSecondary).withAlpha(26),
              valueColor: const AlwaysStoppedAnimation(Color(kColorSecondary)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AbstinenceActive state,
    int days,
    double progress,
  ) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: '本周第',
            value: '${((days % 30) ~/ 7) + 1} 天',
            icon: Icons.calendar_today_outlined,
            color: const Color(kColorPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: '下次里程碑',
            value: '${state.nextMilestoneDays}天',
            icon: Icons.flag_outlined,
            color: const Color(kColorAccent),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: '目标进度',
            value: '${(progress * 100).toInt()}%',
            icon: Icons.trending_up_outlined,
            color: const Color(kColorSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildUrgeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: WarmGradientCard(
        colors: [
          const Color(kColorPrimary),
          const Color(kColorPrimaryDark),
        ],
        padding: EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const UrgePanelPage(),
                transitionsBuilder: (_, animation, __, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    )),
                    child: child,
                  );
                },
              ),
            ),
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bolt, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    '我现在很想',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kBorderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: const Color(kShadowColor),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TriggerLogPage()),
                ),
                borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(kColorSecondary).withAlpha(26),
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(kColorSecondary),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '记录触发',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(kColorTextPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kBorderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: const Color(kShadowColor),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showRelapseConfirmDialog(context),
                borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(kColorWarning).withAlpha(26),
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: const Icon(
                          Icons.refresh,
                          color: Color(kColorWarning),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '记录中断',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(kColorTextPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRelapseDialog(BuildContext context, AbstinenceJustRelapsed state) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(kColorSecondary).withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Color(kColorSecondary),
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '恢复比重新开始更容易',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(kColorTextPrimary),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '你保持了 ${state.previousDays} 天。\n科学研究表明，恢复上一次的戒断状态比重新开始需要的时间更短。',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(kColorTextSecondary),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RelapseSupportPage(
                          previousRecord: state.previousRecord,
                          previousDays: state.previousDays,
                          onComplete: () {
                            context.read<AbstinenceBloc>().add(
                              AbstinenceStarted(goalDays: 30),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('开始破戒分析'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRelapseConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(kColorWarning).withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Color(kColorWarning),
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '确认戒断中断',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(kColorTextPrimary),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '这意味着重新开始计时。是否继续？',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(kColorTextSecondary),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<AbstinenceBloc>().add(AbstinenceRelapsed());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(kColorWarning),
                      ),
                      child: const Text('确认中断'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}