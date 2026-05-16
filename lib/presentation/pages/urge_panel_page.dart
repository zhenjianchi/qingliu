import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../domain/entities/urge_technique.dart';
import 'technique_guide_page.dart';
import 'breathing_guide_page.dart';
import 'grounding_guide_page.dart';
import 'self_dialogue_guide_page.dart';

class UrgePanelPage extends StatefulWidget {
  const UrgePanelPage({super.key});
  @override
  State<UrgePanelPage> createState() => _UrgePanelPageState();
}

class _UrgePanelPageState extends State<UrgePanelPage>
    with SingleTickerProviderStateMixin {
  final _logger = AppLogger.instance;
  int _selectedUrgeLevel = 5;
  List<UrgeTechnique> _sortedTechniques = [];
  bool _showAll = false;
  bool _isLotteryAnimating = false;
  UrgeTechnique? _lotteryResult;
  final _cognitiveController = TextEditingController();
  bool _showCognitive = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _lotteryController;
  late Animation<double> _lotteryAnimation;

  @override
  void initState() {
    super.initState();
    _updateSortedTechniques();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();

    _lotteryController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _lotteryAnimation = CurvedAnimation(
      parent: _lotteryController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _cognitiveController.dispose();
    _slideController.dispose();
    _lotteryController.dispose();
    super.dispose();
  }

  void _updateSortedTechniques() {
    _sortedTechniques = UrgeTechnique.getSortedForUrgeLevel(_selectedUrgeLevel);
  }

  void _onUrgeLevelChanged(int level) {
    setState(() {
      _selectedUrgeLevel = level;
      _updateSortedTechniques();
    });
  }

  Future<void> _playLotteryAnimation() async {
    if (_isLotteryAnimating) return;

    setState(() {
      _isLotteryAnimating = true;
      _lotteryResult = null;
    });

    final random = Random();
    final availableTechs = _sortedTechniques.skip(5).toList();
    if (availableTechs.isEmpty) {
      availableTechs.addAll(_sortedTechniques);
    }

    _lotteryController.reset();
    _lotteryController.forward();

    await Future.delayed(const Duration(milliseconds: 800));

    final selected = availableTechs[random.nextInt(availableTechs.length)];

    setState(() {
      _lotteryResult = selected;
      _isLotteryAnimating = false;
    });
  }

  void _resetLottery() {
    setState(() {
      _lotteryResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F4F8), Color(kColorBackground)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(kPaddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUrgeLevelSection(context),
                      const SizedBox(height: 24),
                      _buildLotteryButton(context),
                      if (_lotteryResult != null) ...[
                        const SizedBox(height: 16),
                        _buildLotteryResultCard(context),
                      ],
                      const SizedBox(height: 24),
                      _buildTechniqueSection(context),
                      const SizedBox(height: 24),
                      _buildCognitiveSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPaddingLarge),
      child: Row(
        children: [
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
            child: const Icon(Icons.bolt, color: Color(kColorPrimary), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '渴望应对',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(kColorAccent),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '智能推荐技术',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: const Color(kColorTextHint),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgeLevelSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(kColorPrimary), Color(0xFF005F8A)],
        ),
        borderRadius: BorderRadius.circular(kBorderRadiusXLarge),
        boxShadow: [
          BoxShadow(
            color: const Color(kColorPrimary).withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.psychology, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          const Text(
            '此刻渴望很正常',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '选择你的渴望强度，系统会推荐最合适的技术',
            style: TextStyle(fontSize: 13, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('1', style: TextStyle(color: Colors.white54, fontSize: 12)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white24,
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _selectedUrgeLevel.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => _onUrgeLevelChanged(v.round()),
                  ),
                ),
              ),
              const Text('10', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Text(
              '强度 $_selectedUrgeLevel',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotteryButton(BuildContext context) {
    return GestureDetector(
      onTap: _isLotteryAnimating ? null : _playLotteryAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withAlpha(102),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_isLotteryAnimating)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else
              const Icon(Icons.casino, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎲 随机抽一个',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '不知道选什么？让系统随机推荐',
                    style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(179)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLotteryResultCard(BuildContext context) {
    final tech = _lotteryResult!;
    return ScaleTransition(
      scale: _lotteryAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          border: Border.all(color: const Color(0xFF667EEA), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withAlpha(77),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: tech.iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Center(
                    child: Icon(tech.icon, color: tech.iconColor, size: 28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            '🎯 推荐技术',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF667EEA),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '适合强度 ${tech.recommendedUrgeLevel}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(kColorTextHint),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tech.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(kColorTextPrimary),
                        ),
                      ),
                      Text(
                        '约${tech.durationSeconds}秒 · ${tech.keyMechanism}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(kColorTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetLottery,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF667EEA)),
                      foregroundColor: const Color(0xFF667EEA),
                    ),
                    child: const Text('重新抽'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _navigateToTechnique(tech),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                    ),
                    child: const Text('执行'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueSection(BuildContext context) {
    final displayList = _showAll ? _sortedTechniques : _sortedTechniques.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '推荐技术',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(kColorTextPrimary),
              ),
            ),
            const Spacer(),
            if (!_showAll && _sortedTechniques.length > 5)
              TextButton(
                onPressed: () => setState(() => _showAll = true),
                child: Text(
                  '查看全部 (${_sortedTechniques.length})',
                  style: const TextStyle(fontSize: 13),
                ),
              )
            else if (_showAll)
              TextButton(
                onPressed: () => setState(() => _showAll = false),
                child: const Text('收起', style: TextStyle(fontSize: 13)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...displayList.asMap().entries.map((entry) {
          final index = entry.key;
          final tech = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTechniqueCard(tech, index),
          );
        }),
      ],
    );
  }

  Widget _buildTechniqueCard(UrgeTechnique tech, int index) {
    final isRecommended = tech.isRecommended;
    final matchScore = _getMatchScore(tech);

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
          border: isRecommended ? Border.all(color: const Color(kColorAccent), width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: isRecommended
                  ? const Color(kColorAccent).withAlpha(38)
                  : const Color(kShadowColor),
              blurRadius: isRecommended ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _navigateToTechnique(tech),
            borderRadius: BorderRadius.circular(kBorderRadiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: tech.iconColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    child: Center(
                      child: Icon(tech.icon, color: tech.iconColor, size: 28),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                tech.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(kColorTextPrimary),
                                ),
                              ),
                            ),
                            if (isRecommended) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(kColorAccent),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '推荐',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '约${tech.durationSeconds}秒 · ${tech.keyMechanism}',
                          style: const TextStyle(fontSize: 12, color: Color(kColorTextSecondary)),
                        ),
                        const SizedBox(height: 4),
                        _buildMatchIndicator(tech, matchScore),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(kColorBackground),
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    child: const Icon(Icons.arrow_forward_ios, color: Color(kColorTextHint), size: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchIndicator(UrgeTechnique tech, int score) {
    Color color;
    String label;
    if (score >= 80) {
      color = const Color(kColorAccent);
      label = '非常匹配';
    } else if (score >= 60) {
      color = const Color(kColorPrimary);
      label = '匹配';
    } else {
      color = const Color(kColorTextHint);
      label = '一般';
    }

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          '适合强度 ${tech.minUrgeLevel}-${tech.maxUrgeLevel}',
          style: const TextStyle(fontSize: 10, color: Color(kColorTextHint)),
        ),
      ],
    );
  }

  int _getMatchScore(UrgeTechnique tech) {
    int score = 100 - (tech.displayPriority * 5);
    if (_selectedUrgeLevel >= tech.minUrgeLevel && _selectedUrgeLevel <= tech.maxUrgeLevel) {
      score += 30;
      final distance = (_selectedUrgeLevel - tech.recommendedUrgeLevel).abs();
      score -= distance * 5;
    } else {
      score -= 50;
    }
    return score.clamp(0, 100);
  }

  Widget _buildCognitiveSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        boxShadow: [
          BoxShadow(color: const Color(kShadowColor), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _showCognitive = !_showCognitive),
              borderRadius: BorderRadius.circular(kBorderRadiusLarge),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(kColorSecondary).withAlpha(26),
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      child: const Icon(Icons.edit_note, color: Color(kColorSecondary), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '写下我现在在想什么',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(kColorTextPrimary)),
                          ),
                          const SizedBox(height: 4),
                          Text('认知重构，帮助你理性看待', style: TextStyle(fontSize: 12, color: const Color(kColorTextHint))),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: _showCognitive ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down, color: Color(kColorTextHint)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showCognitive) _buildCognitiveInput(context),
        ],
      ),
    );
  }

  Widget _buildCognitiveInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 12),
          const Text('现在脑海中出现的画面或想法是什么？', style: TextStyle(fontSize: 13, color: Color(kColorTextSecondary))),
          const SizedBox(height: 12),
          TextField(
            controller: _cognitiveController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '把此刻的想法写下来……',
              hintStyle: const TextStyle(color: Color(kColorTextHint)),
              filled: true,
              fillColor: const Color(kColorSurfaceAlt),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(kColorAccent).withAlpha(26),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(kColorAccent), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '这个想法是真的吗，还是多巴胺在骗你？',
                    style: TextStyle(color: Color(kColorAccent), fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _logger.info('Cognitive log: ${_cognitiveController.text}', tag: 'UrgePanel');
                _cognitiveController.clear();
                setState(() => _showCognitive = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('已记录，继续加油 💪'),
                    backgroundColor: const Color(kColorPrimary),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
                  ),
                );
              },
              child: const Text('保存并继续'),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTechnique(UrgeTechnique tech) {
    Widget page;
    switch (tech.id) {
      case 'T4':
        page = const BreathingGuidePage();
        break;
      case 'T5':
        page = const GroundingGuidePage();
        break;
      case 'T11':
        page = SelfDialogueGuidePage(technique: tech);
        break;
      default:
        page = TechniqueGuidePage(technique: tech);
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
      ),
    );
  }
}