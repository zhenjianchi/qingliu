import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../data/datasources/local_datasource.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _logger = AppLogger.instance;
  int _goalDays = 30;
  bool _notificationsEnabled = true;
  bool _milestoneAlertsEnabled = true;
  bool _darkModeEnabled = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final ds = LocalDataSource.instance;
      final goal = await ds.getSetting(kStorageGoalDays);
      final notif = await ds.getSetting(kStorageNotificationsEnabled);
      final milestone = await ds.getSetting(kStorageMilestoneAlertsEnabled);
      final dark = await ds.getSetting(kStorageDarkModeEnabled);

      setState(() {
        if (goal != null) _goalDays = int.tryParse(goal) ?? 30;
        if (notif != null) _notificationsEnabled = notif == 'true';
        if (milestone != null) _milestoneAlertsEnabled = milestone == 'true';
        if (dark != null) _darkModeEnabled = dark == 'true';
      });
    } catch (e, st) {
      _logger.error('Failed to load settings', error: e, stackTrace: st);
    }
  }

  Future<void> _saveSetting(String key, String value) async {
    await LocalDataSource.instance.setSetting(key, value);
    _logger.info('Setting saved: $key = $value', tag: 'Settings');
  }

  Future<void> _exportData() async {
    if (_isExporting) return;
    setState(() => _isExporting = true);

    try {
      final ds = LocalDataSource.instance;
      final abstinence = await ds.getAbstinenceRecords();
      final triggers = await ds.getTriggerLogs();
      final urgeLogs = await ds.getUrgeLogs();
      final milestones = await ds.getMilestones();

      final exportData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'abstinenceRecords': abstinence,
        'triggerLogs': triggers,
        'urgeLogs': urgeLogs,
        'milestones': milestones,
        'settings': {
          'goalDays': _goalDays,
          'notificationsEnabled': _notificationsEnabled,
          'milestoneAlertsEnabled': _milestoneAlertsEnabled,
        },
      };

      final json = const JsonEncoder.withIndent('  ').convert(exportData);
      final fileName = 'qingliu_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final exportDir = Directory(path.join(Directory.current.path, 'exports'));
      await exportDir.create(recursive: true);
      final filePath = path.join(exportDir.path, fileName);
      await File(filePath).writeAsString(json);

      _logger.info('Data exported to $filePath', tag: 'Settings');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('数据已导出至 exports/$fileName')),
        );
      }
    } catch (e, st) {
      _logger.error('Failed to export data', error: e, stackTrace: st);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认清除所有数据'),
        content: const Text(
          '此操作不可撤销。\n所有戒断记录、触发日志、渴望记录都将被永久删除。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Color(kColorError)),
            child: const Text('确认清除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await LocalDataSource.instance.clearAllData();
      _logger.warning('All data cleared by user', tag: 'Settings');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('所有数据已清除')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(kPaddingMedium),
        children: [
          // Abstinence goal
          _buildSectionTitle('戒断目标'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('自定义戒断天数', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [7, 14, 30, 60, 90, 180].map((days) {
                    final selected = days == _goalDays;
                    return ChoiceChip(
                      label: Text('$days 天'),
                      selected: selected,
                      selectedColor: Color(kColorPrimary),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Color(kColorTextPrimary),
                      ),
                      onSelected: (_) async {
                        setState(() => _goalDays = days);
                        await _saveSetting(kStorageGoalDays, '$days');
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Notifications
          _buildSectionTitle('通知管理'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                _buildSwitchTile(
                  title: '预测性提醒',
                  subtitle: '在高风险时段发送健康提醒',
                  value: _notificationsEnabled,
                  onChanged: (v) async {
                    setState(() => _notificationsEnabled = v);
                    await _saveSetting(kStorageNotificationsEnabled, '$v');
                  },
                ),
                const Divider(),
                _buildSwitchTile(
                  title: '里程碑提醒',
                  subtitle: '达成里程碑时发送庆祝通知',
                  value: _milestoneAlertsEnabled,
                  onChanged: (v) async {
                    setState(() => _milestoneAlertsEnabled = v);
                    await _saveSetting(kStorageMilestoneAlertsEnabled, '$v');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Appearance
          _buildSectionTitle('外观'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: _buildSwitchTile(
              title: '深色模式',
              subtitle: '夜间使用，减少屏幕亮度对睡眠的影响',
              value: _darkModeEnabled,
              onChanged: (v) async {
                setState(() => _darkModeEnabled = v);
                await _saveSetting(kStorageDarkModeEnabled, '$v');
              },
            ),
          ),
          const SizedBox(height: 20),

          // Data management
          _buildSectionTitle('数据管理'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.download, color: Color(kColorSecondary)),
                  title: const Text('导出数据（JSON）'),
                  subtitle: const Text('将所有本地数据导出为JSON文件'),
                  trailing: _isExporting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.chevron_right),
                  onTap: _isExporting ? null : _exportData,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_forever, color: Color(kColorError)),
                  title: const Text('清除所有数据', style: TextStyle(color: Color(kColorError))),
                  subtitle: const Text('永久删除所有本地数据'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _clearAllData,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About
          _buildSectionTitle('关于'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.water_drop, color: Color(kColorSecondary)),
                  title: const Text('清流'),
                  subtitle: const Text('健康习惯管理工具'),
                  trailing: Text(
                    'v$kAppVersion',
                    style: const TextStyle(color: Color(kColorTextSecondary)),
                  ),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.privacy_tip_outlined, color: Color(kColorSecondary)),
                  title: const Text('隐私政策'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => _showPrivacyPolicy(),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.warning_amber_outlined, color: Color(kColorWarning)),
                  title: const Text('免责声明'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDisclaimer(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(kColorTextSecondary),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Color(kColorSurface),
      borderRadius: BorderRadius.circular(kBorderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(13),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(kColorTextSecondary))),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: Color(kColorSecondary),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Text(
            '清流承诺保护您的隐私。\n\n'
            '• 所有数据仅存储在您的设备本地\n'
            '• 数据不会上传至任何服务器\n'
            '• 应用内无任何广告和第三方追踪\n'
            '• 您的数据仅您可访问\n'
            '• 可随时清除所有本地数据',
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭'))],
      ),
    );
  }

  void _showDisclaimer() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('免责声明'),
        content: const SingleChildScrollView(
          child: Text(
            '清流是一款健康习惯辅助工具，非专业医学或心理咨询产品。\n\n'
            '• 本应用不能替代专业的医学诊断或治疗\n'
            '• 如有严重困扰，建议寻求专业帮助\n'
            '• 戒断过程中的反复是正常的，不要过度自责\n'
            '• 心理健康公益热线：全国心理援助热线 400-161-9995',
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭'))],
      ),
    );
  }
}