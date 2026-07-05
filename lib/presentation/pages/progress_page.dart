import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../data/datasources/local_datasource.dart';
import '../../domain/entities/abstinence_record.dart';
import '../../domain/entities/log_entries.dart';
import '../blocs/abstinence_bloc.dart';
import '../widgets/day_wall.dart';
import '../widgets/tactile_card.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});
  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final _logger = AppLogger.instance;
  DailySummary? _dailySummary;
  WeeklyReport? _weeklyReport;
  List<TriggerLog> _recentTriggers = [];
  List<MilestoneAchievement> _milestones = [];
  int _abstinenceDays = 0;
  int _goalDays = 30;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final ds = LocalDataSource.instance;

      // Load milestones
      final milestoneMaps = await ds.getMilestones();
      final milestones = milestoneMaps.map((m) => MilestoneAchievement.fromJson({
        'id': m['id'],
        'targetDays': m['target_days'],
        'achievedAt': m['achieved_at'],
        'name': m['name'],
        'emoji': m['emoji'],
      })).toList();

      // Load recent triggers
      final triggerMaps = await ds.getTriggerLogs(limit: 10);
      final triggers = triggerMaps.map((m) => TriggerLog.fromJson(m)).toList();

      // Calculate current abstinence days
      final activeRecordMap = await ds.getActiveAbstinenceRecord();
      int days = 0;
      int goal = 30;
      if (activeRecordMap != null) {
        final startTime = DateTime.parse(activeRecordMap['start_time'] as String);
        days = DateTime.now().difference(startTime).inDays;
        goal = activeRecordMap['goal_days'] as int;
      }

      setState(() {
        _milestones = milestones;
        _recentTriggers = triggers;
        _abstinenceDays = days;
        _goalDays = goal;
        _dailySummary = _buildDailySummary(triggers, days);
        _weeklyReport = _buildWeeklyReport(triggers, days);
      });
    } catch (e, st) {
      _logger.error('Failed to load progress data', error: e, stackTrace: st);
    }
  }

  DailySummary _buildDailySummary(List<TriggerLog> triggers, int days) {
    final today = DateTime.now();
    final todayTriggers = triggers.where((t) =>
      t.timestamp.year == today.year &&
      t.timestamp.month == today.month &&
      t.timestamp.day == today.day
    ).toList();
    return DailySummary(
      date: today,
      abstinenceDays: days,
      triggerCount: todayTriggers.length,
      urgeResponseCount: 0,
      urgeResponseCompletedCount: 0,
      avgUrgeLevel: todayTriggers.isEmpty
        ? 0
        : (todayTriggers.map((t) => t.urgeLevel).reduce((a, b) => a + b) / todayTriggers.length).round(),
      moodScore: 3,
    );
  }

  WeeklyReport _buildWeeklyReport(List<TriggerLog> triggers, int days) {
    // Group by emotion
    final emotionCounts = <String, int>{};
    for (final t in triggers) {
      emotionCounts[t.emotion] = (emotionCounts[t.emotion] ?? 0) + 1;
    }
    return WeeklyReport(
      weekStart: DateTime.now().subtract(const Duration(days: 7)),
      totalAbstinenceDays: days,
      previousWeekDays: (days * 0.7).round(),
      triggerEmotionCounts: emotionCounts,
      totalTriggers: triggers.length,
      urgeResponsesCompleted: 0,
      urgeResponsesTotal: 0,
      milestonesAchieved: _milestones,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的进度')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(kPaddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Monthly summary card
              _buildCard(
                title: '本月数据',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('$_abstinenceDays', '戒断天数', Color(kColorPrimary)),
                    _buildStatColumn('${_dailySummary?.triggerCount ?? 0}', '触发次数', Color(kColorWarning)),
                    _buildStatColumn(
                      '${(_dailySummary?.completionRate ?? 0) * 100}%',
                      '渴望应对完成率',
                      Color(kColorAccent),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Mood timeline (DayWall)
              _buildCard(
                title: '心情时间墙',
                child: DayWall(
                  entries: List.generate(
                    30,
                    (i) => DayEntry(
                      date: DateTime.now().subtract(Duration(days: 29 - i)),
                      moodLevel: ((i * 7) % 5) + 1,
                      hasRecord: i > 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Weekly comparison
              _buildCard(
                title: '本周 vs 上周',
                child: SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 30,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (v, _) => Text(
                              v == 0 ? '本周' : '上周',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: _abstinenceDays.toDouble(),
                              color: Color(kColorSecondary),
                              width: 40,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: (_weeklyReport?.previousWeekDays ?? 0).toDouble(),
                              color: Color(kColorSecondary).withAlpha(128),
                              width: 40,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Trigger emotion distribution
              if (_weeklyReport != null && _weeklyReport!.triggerEmotionCounts.isNotEmpty)
                _buildCard(
                  title: '触发诱因分布',
                  child: Column(
                    children: _weeklyReport!.triggerEmotionCounts.entries
                      .toList()
                      .take(4)
                      .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _buildEmotionBar(e.key, e.value, _weeklyReport!.totalTriggers),
                      )).toList(),
                  ),
                ),
              const SizedBox(height: 16),

              // Milestones
              _buildCard(
                title: '里程碑成就',
                child: Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: kMilestones.map((days) {
                    final achieved = _milestones.any((m) => m.targetDays == days);
                    return _buildMilestoneChip(days, achieved);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Recent triggers
              if (_recentTriggers.isNotEmpty)
                _buildCard(
                  title: '最近触发记录',
                  child: Column(
                    children: _recentTriggers.take(5).map((log) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Color(kColorWarning).withAlpha(26),
                        child: Text(
                          '${log.urgeLevel}',
                          style: TextStyle(
                            color: Color(kColorWarning),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(log.emotion),
                      subtitle: Text(_formatTime(log.timestamp)),
                      dense: true,
                    )).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(kColorTextSecondary)),
        ),
      ],
    );
  }

  Widget _buildEmotionBar(String emotion, int count, int total) {
    final percent = total > 0 ? (count / total * 100) : 0;
    return Row(
      children: [
        SizedBox(width: 60, child: Text(emotion, style: const TextStyle(fontSize: 13))),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Color(kColorBackground),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent / 100,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color(kColorPrimary),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 45, child: Text('${percent.toInt()}%', style: const TextStyle(fontSize: 12))),
      ],
    );
  }

  Widget _buildMilestoneChip(int days, bool achieved) {
    final emoji = kMilestoneEmojis[days] ?? '🎯';
    final name = kMilestoneNames[days] ?? '$days天';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: achieved ? Color(kColorAccent).withAlpha(26) : Color(kColorBackground),
        borderRadius: BorderRadius.circular(20),
        border: achieved ? Border.all(color: Color(kColorAccent)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            '$days天',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: achieved ? Color(kColorAccent) : Color(kColorTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    return '${diff.inDays}天前';
  }
}