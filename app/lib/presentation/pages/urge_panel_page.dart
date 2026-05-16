import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../domain/entities/urge_technique.dart';
import 'technique_guide_page.dart';

class UrgePanelPage extends StatefulWidget {
  const UrgePanelPage({super.key});
  @override
  State<UrgePanelPage> createState() => _UrgePanelPageState();
}

class _UrgePanelPageState extends State<UrgePanelPage> {
  final _logger = AppLogger.instance;
  int _selectedUrgeLevel = 5;
  List<UrgeTechnique> _displayedTechniques = [];
  bool _showCognitive = false;
  final _cognitiveController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _randomizeTechniques();
  }

  void _randomizeTechniques() {
    final all = List<UrgeTechnique>.from(UrgeTechnique.all);
    all.shuffle();
    // Ensure T1 (cold water) is always recommended
    _displayedTechniques = all.take(3).toList();
    // Put recommended first
    _displayedTechniques.sort((a, b) {
      if (a.isRecommended) return -1;
      if (b.isRecommended) return 1;
      return 0;
    });
  }

  @override
  void dispose() {
    _cognitiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('渴望应对'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(kColorPrimary),
                      Color(kColorSecondary),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(kBorderRadiusLarge),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.bolt, color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      '此刻渴望很正常',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      '你完全可以渡过去',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Urge level slider
              Text('渴望等级', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('1', style: TextStyle(color: Color(kColorTextHint))),
                  Expanded(
                    child: Slider(
                      value: _selectedUrgeLevel.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$_selectedUrgeLevel',
                      onChanged: (v) => setState(() => _selectedUrgeLevel = v.round()),
                    ),
                  ),
                  const Text('10', style: TextStyle(color: Color(kColorTextHint))),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(kColorSecondary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_selectedUrgeLevel',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Technique buttons
              Text(
                '选择一个立即执行',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ..._displayedTechniques.map((tech) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTechniqueButton(tech),
              )),
              const SizedBox(height: 12),

              // Cognitive refactoring entry
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(kColorBackground),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  border: Border.all(color: Color(kColorSecondary).withAlpha(51)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_note, color: Color(kColorSecondary)),
                        const SizedBox(width: 8),
                        Text(
                          '写下我现在在想什么',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(_showCognitive
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                          onPressed: () => setState(() => _showCognitive = !_showCognitive),
                        ),
                      ],
                    ),
                    if (_showCognitive) ...[
                      const SizedBox(height: 8),
                      const Text(
                        '现在脑海中出现的画面或想法是什么？',
                        style: TextStyle(color: Color(kColorTextSecondary), fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _cognitiveController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: '把此刻的想法写下来……',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '这个想法是真的吗，还是多巴胺在骗你？',
                        style: TextStyle(
                          color: Color(kColorAccent),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _logger.info(
                              'Cognitive log: ${_cognitiveController.text}',
                              tag: 'UrgePanel',
                            );
                            _cognitiveController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('已记录，继续加油')),
                            );
                          },
                          child: const Text('保存并继续'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechniqueButton(UrgeTechnique tech) {
    return Material(
      color: Color(kColorSurface),
      borderRadius: BorderRadius.circular(kBorderRadius),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TechniqueGuidePage(technique: tech),
          ),
        ),
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: tech.isRecommended
              ? Border.all(color: Color(kColorAccent), width: 2)
              : null,
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: Row(
            children: [
              Text(tech.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          tech.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (tech.isRecommended) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(kColorAccent),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '推荐',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '约${tech.durationSeconds}秒 · ${tech.keyMechanism}',
                      style: const TextStyle(
                        color: Color(kColorTextSecondary),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(kColorTextHint)),
            ],
          ),
        ),
      ),
    );
  }
}