import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_constants.dart';
import '../blocs/abstinence_bloc.dart';
import 'urge_panel_page.dart';
import 'trigger_log_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('清流'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () { /* TODO: notifications */ },
          ),
        ],
      ),
      body: BlocConsumer<AbstinenceBloc, AbstinenceState>(
        listener: (context, state) {
          if (state is AbstinenceJustRelapsed) {
            _showRelapseDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state is AbstinenceLoading || state is AbstinenceInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AbstinenceNoRecord) {
            return _buildNoRecordView(context);
          }

          if (state is AbstinenceActive) {
            return _buildActiveView(context, state);
          }

          if (state is AbstinenceError) {
            return Center(child: Text('错误: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNoRecordView(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.water_drop_outlined,
              size: 80,
              color: Color(kColorSecondary),
            ),
            const SizedBox(height: 24),
            Text(
              '开启你的清流之旅',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              '设定一个戒断目标，我们一起完成',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildGoalSelector(context),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startAbstinence(context, 30),
                child: const Text('开始戒断 · 30天挑战'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _startAbstinence(context, 90),
              child: const Text('进阶挑战 · 90天'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSelector(BuildContext context) {
    return Column(
      children: [
        Text('选择你的目标天数', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: [7, 14, 30, 60, 90].map((days) {
            return OutlinedButton(
              onPressed: () => _startAbstinence(context, days),
              child: Text('$days 天'),
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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          children: [
            // Ring progress
            CircularPercentIndicator(
              radius: 120,
              lineWidth: 12,
              percent: progress,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$days',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(kColorPrimary),
                    ),
                  ),
                  Text(
                    '天 $hours 时 $minutes 分',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(kColorTextSecondary),
                    ),
                  ),
                ],
              ),
              progressColor: Color(kColorSecondary),
              backgroundColor: Color(kColorSecondary).withAlpha(51),
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 800,
            ),
            const SizedBox(height: 16),

            // Milestone info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(kColorAccent).withAlpha(26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Color(kColorAccent), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '连续戒断第 ${(days ~/ 7) + 1} 周',
                    style: const TextStyle(
                      color: Color(kColorAccent),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Urge button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UrgePanelPage()),
                ),
                icon: const Icon(Icons.bolt),
                label: const Text('⚡  我现在很想'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(kColorSecondary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick actions row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TriggerLogPage()),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('记录触发'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRelapseConfirmDialog(context),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('记录中断'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(kColorWarning),
                      side: BorderSide(color: Color(kColorWarning)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats strip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(kColorSurface),
                borderRadius: BorderRadius.circular(kBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('本周第', '${((days % 30) ~/ 7) + 1} 天', Icons.calendar_today),
                  _buildStatItem('下次里程碑', '${state.nextMilestoneDays}天', Icons.flag),
                  _buildStatItem('目标进度', '${(progress * 100).toInt()}%', Icons.trending_up),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Color(kColorSecondary), size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(kColorTextSecondary))),
      ],
    );
  }

  void _showRelapseDialog(BuildContext context, AbstinenceJustRelapsed state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Color(kColorSecondary)),
            SizedBox(width: 8),
            Text('恢复比重新开始更容易'),
          ],
        ),
        content: Text(
          '你保持了 ${state.previousDays} 天。\n'
          '科学研究表明，恢复上一次的戒断状态比重新开始需要的时间更短。\n\n'
          '继续前行，你可以的。',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AbstinenceBloc>().add(AbstinenceStarted(goalDays: 30));
            },
            child: const Text('重新开始戒断'),
          ),
        ],
      ),
    );
  }

  void _showRelapseConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认戒断中断'),
        content: const Text('这意味着重新开始计时。是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AbstinenceBloc>().add(AbstinenceRelapsed());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(kColorWarning),
            ),
            child: const Text('确认中断'),
          ),
        ],
      ),
    );
  }
}