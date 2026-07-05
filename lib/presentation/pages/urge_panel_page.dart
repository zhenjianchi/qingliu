import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';
import '../../domain/entities/urge_technique.dart';
import '../widgets/atoms.dart';
import '../widgets/tactile_card.dart';
import 'technique_guide_page.dart';
import 'breathing_guide_page.dart';
import 'grounding_guide_page.dart';
import 'self_dialogue_guide_page.dart';

/// V2.0 Urge Panel - Semantic 3-choice intensity selector + Lingo design
class UrgePanelPage extends StatefulWidget {
  const UrgePanelPage({super.key});

  @override
  State<UrgePanelPage> createState() => _UrgePanelPageState();
}

class _UrgePanelPageState extends State<UrgePanelPage>
    with TickerProviderStateMixin {
  final _logger = AppLogger.instance;

  // Semantic urgency level: low / mid / high
  int _urgency = 2; // 1=low, 2=mid, 3=high
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

  // User success counter (demo)
  final int _successCount = 12;

  @override
  void initState() {
    super.initState();
    _updateSortedTechniques();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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

  void _setUrgency(int level, int actualValue) {
    setState(() {
      _urgency = level;
      _selectedUrgeLevel = actualValue;
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
    final availableTechs = _sortedTechniques.skip(3).toList();
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
    setState(() => _lotteryResult = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),

                // Success counter (always visible)
                _buildSuccessCounter(context),
                const SizedBox(height: 24),

                // Step 1: Urgency selection (semantic 3-choice)
                _buildUrgencySection(context),
                const SizedBox(height: 24),

                // Step 2: Top recommendation
                _buildTopRecommendation(context),
                if (_lotteryResult != null) ...[
                  const SizedBox(height: 16),
                  _buildLotteryResultCard(context),
                ],
                const SizedBox(height: 16),

                // Step 3: Other techniques
                _buildTechniqueSection(context),
                const SizedBox(height: 24),

                // Step 4: Cognitive reframing
                _buildCognitiveSection(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(kColorPrimary),
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          child: const Icon(Icons.bolt, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '渴望应对',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '我们一起度过这 90 秒',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(kColorTextSecondary),
                ),
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
    );
  }

  Widget _buildSuccessCounter(BuildContext context) {
    return TactileCard(
      borderColor: const Color(kColorSecondary),
      child: Row(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你已经成功应对 $_successCount 次',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(kColorSecondaryDark),
                  ),
                ),
                Text(
                  '每多一次，你的大脑就更强一点',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(kColorTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '此刻你的渴望是什么感觉？',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _UrgencyCard(
                emoji: '😌',
                label: '有点想',
                range: '1-3',
                color: const Color(kColorWarning),
                selected: _urgency == 1,
                onTap: () => _setUrgency(1, 2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _UrgencyCard(
                emoji: '😰',
                label: '很强烈',
                range: '4-7',
                color: const Color(0xFFFF8C42),
                selected: _urgency == 2,
                onTap: () => _setUrgency(2, 5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _UrgencyCard(
                emoji: '🔥',
                label: '压不住',
                range: '8-10',
                color: const Color(kColorDanger),
                selected: _urgency == 3,
                onTap: () => _setUrgency(3, 8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopRecommendation(BuildContext context) {
    final topTech = _sortedTechniques.isNotEmpty ? _sortedTechniques.first : null;
    if (topTech == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🎯', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              '先试试这个 →',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(kColorPrimary),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PressableCard(
          onTap: () => _navigateToTechnique(topTech),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: topTech.iconColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: Center(
                  child: Icon(topTech.icon, color: topTech.iconColor, size: 32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topTech.name,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Pill(
                          label: '约 ${topTech.durationSeconds}s',
                          color: const Color(kColorPrimary),
                          fontSize: 11,
                        ),
                        const SizedBox(width: 8),
                        Pill(
                          label: topTech.keyMechanism,
                          color: topTech.iconColor,
                          fontSize: 11,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(kColorPrimary), size: 16),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton.icon(
            onPressed: _isLotteryAnimating ? null : _playLotteryAnimation,
            icon: _isLotteryAnimating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.casino, color: Color(kColorSecondary)),
            label: Text(
              '换一个',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(kColorSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLotteryResultCard(BuildContext context) {
    final tech = _lotteryResult!;
    return ScaleTransition(
      scale: _lotteryAnimation,
      child: TactileCard(
        borderColor: const Color(kColorSecondary),
        onTap: () => _navigateToTechnique(tech),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: tech.iconColor.withAlpha(40),
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
                  Text(
                    '试试这个 ✨',
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: const Color(kColorSecondary),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tech.name,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${tech.durationSeconds}s · ${tech.keyMechanism}',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(kColorTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueSection(BuildContext context) {
    final displayList = _showAll
        ? _sortedTechniques
        : _sortedTechniques.skip(1).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '其他选择',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            if (!_showAll && _sortedTechniques.length > 6)
              TextButton(
                onPressed: () => setState(() => _showAll = true),
                child: Text(
                  '查看全部 (${_sortedTechniques.length})',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(kColorPrimary),
                  ),
                ),
              )
            else if (_showAll)
              TextButton(
                onPressed: () => setState(() => _showAll = false),
                child: Text(
                  '收起',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(kColorPrimary),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...displayList.asMap().entries.map((entry) {
          final tech = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildTechniqueTile(tech),
          );
        }),
      ],
    );
  }

  Widget _buildTechniqueTile(UrgeTechnique tech) {
    final inRange = _selectedUrgeLevel >= tech.minUrgeLevel &&
        _selectedUrgeLevel <= tech.maxUrgeLevel;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToTechnique(tech),
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: inRange
                ? tech.iconColor.withAlpha(20)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(
              color: inRange ? tech.iconColor : const Color(0xFFEAEAEA),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tech.iconColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(tech.icon, color: tech.iconColor, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tech.name,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tech.durationSeconds}s · ${tech.keyMechanism}',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(kColorTextSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              if (inRange)
                Pill(
                  label: '适合',
                  color: tech.iconColor,
                  fontSize: 10,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCognitiveSection(BuildContext context) {
    return TactileCard(
      onTap: () => setState(() => _showCognitive = !_showCognitive),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(kColorSecondary).withAlpha(40),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: const Icon(Icons.edit_note,
                    color: Color(kColorSecondary), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '写下我现在在想什么',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '认知重构',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(kColorTextHint),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: _showCognitive ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down,
                    color: Color(kColorTextHint)),
              ),
            ],
          ),
          if (_showCognitive) _buildCognitiveInput(context),
        ],
      ),
    );
  }

  Widget _buildCognitiveInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 12),
          TextField(
            controller: _cognitiveController,
            maxLines: 3,
            style: GoogleFonts.nunito(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: '现在脑海中出现的画面或想法...',
              hintStyle: GoogleFonts.nunito(
                color: const Color(kColorTextHint),
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: const Color(kColorSurfaceAlt),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(kColorSecondary).withAlpha(30),
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: Color(kColorSecondary), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '这个想法是真的吗？还是多巴胺在骗你？',
                    style: GoogleFonts.nunito(
                      color: const Color(kColorSecondaryDark),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _logger.info('Cognitive: ${_cognitiveController.text}', tag: 'UrgePanel');
                _cognitiveController.clear();
                setState(() => _showCognitive = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '已记录，继续加油 💪',
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
                    ),
                    backgroundColor: const Color(kColorPrimary),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: Text(
                '保存并继续',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
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
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class _UrgencyCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String range;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _UrgencyCard({
    required this.emoji,
    required this.label,
    required this.range,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? color : color.withAlpha(30),
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.all(
            color: color,
            width: selected ? 3 : 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withAlpha(102),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: selected ? 40 : 32),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : color,
              ),
            ),
            Text(
              range,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: selected
                    ? Colors.white.withAlpha(204)
                    : color.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }
}