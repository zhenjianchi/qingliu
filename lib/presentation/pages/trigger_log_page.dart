import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../data/datasources/local_datasource.dart';
import '../../domain/entities/log_entries.dart';

class TriggerLogPage extends StatefulWidget {
  const TriggerLogPage({super.key});
  @override
  State<TriggerLogPage> createState() => _TriggerLogPageState();
}

class _TriggerLogPageState extends State<TriggerLogPage> {
  final _logger = AppLogger.instance;
  final _uuid = const Uuid();
  final _noteController = TextEditingController();

  String _selectedEmotion = kTriggerEmotions.first;
  int _urgeLevel = 5;
  String _selectedLocation = '家中';
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveLog() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final log = TriggerLog(
        id: _uuid.v4(),
        timestamp: DateTime.now(),
        emotion: _selectedEmotion,
        urgeLevel: _urgeLevel,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        location: _selectedLocation,
      );
      await LocalDataSource.instance.insertTriggerLog(log.toJson());
      _logger.info(
        'Trigger log saved: ${log.emotion}, urge=${log.urgeLevel}',
        tag: 'TriggerLog',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('触发记录已保存')),
        );
        Navigator.pop(context);
      }
    } catch (e, st) {
      _logger.error('Failed to save trigger log', error: e, stackTrace: st);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('记录触发'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(kColorSecondary).withAlpha(26),
                  borderRadius: BorderRadius.circular(kBorderRadiusSmall),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Color(kColorSecondary), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '记录触发事件可以帮助你识别自己的高风险模式',
                        style: TextStyle(color: Color(kColorSecondary), fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Emotion selector
              Text('当前情绪状态', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kTriggerEmotions.map((e) {
                  final selected = e == _selectedEmotion;
                  return ChoiceChip(
                    label: Text(e),
                    selected: selected,
                    selectedColor: Color(kColorPrimary),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Color(kColorTextPrimary),
                    ),
                    onSelected: (_) => setState(() => _selectedEmotion = e),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Urge level
              Text('渴望程度', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('低', style: TextStyle(color: Color(kColorTextHint))),
                  Expanded(
                    child: Slider(
                      value: _urgeLevel.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$_urgeLevel',
                      onChanged: (v) => setState(() => _urgeLevel = v.round()),
                    ),
                  ),
                  const Text('高', style: TextStyle(color: Color(kColorTextHint))),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(_urgeLevel > 7 ? kColorWarning : kColorSecondary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_urgeLevel',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Location
              Text('地点', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['家中', '宿舍', '公司', '其他'].map((loc) {
                  final selected = loc == _selectedLocation;
                  return ChoiceChip(
                    label: Text(loc),
                    selected: selected,
                    selectedColor: Color(kColorPrimary),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Color(kColorTextPrimary),
                    ),
                    onSelected: (_) => setState(() => _selectedLocation = loc),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Note
              Text('备注（可选）', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '写下此刻的具体情境……',
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveLog,
                  child: _saving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('保存记录'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}