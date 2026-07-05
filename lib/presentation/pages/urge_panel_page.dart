import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/urge_technique.dart';
import 'breathing_guide_page.dart';
import 'grounding_guide_page.dart';
import 'self_dialogue_guide_page.dart';
import 'technique_guide_page.dart';
import 'reflection_page.dart';

/// V3.0 Urge Panel
/// 参考: doc/design/20260705/HTML/mobile-ios.html (Screen 02)
///
/// - "渴望来袭？" header
/// - Strength slider 1-10
/// - 3 recommended technique cards
/// - 随机抽卡 card (dashed)
/// - 写下此刻想法 (可选)
/// - ✓ 成功应对 button
class UrgePanelPage extends StatefulWidget {
  const UrgePanelPage({super.key});
  @override
  State<UrgePanelPage> createState() => _UrgePanelPageState();
}

class _UrgePanelPageState extends State<UrgePanelPage> {
  int _urgeLevel = 7;
  List<UrgeTechnique> _sortedTechniques = [];
  bool _showAll = false;
  bool _isLotteryAnimating = false;
  UrgeTechnique? _lotteryResult;

  @override
  void initState() {
    super.initState();
    _updateSorted();
  }

  void _updateSorted() {
    _sortedTechniques = UrgeTechnique.getSortedForUrgeLevel(_urgeLevel);
  }

  String _urgencyLabel(int level) {
    if (level <= 3) return '微弱';
    if (level <= 7) return '中等偏高';
    return '强烈';
  }

  void _onLevelChanged(int v) {
    setState(() {
      _urgeLevel = v;
      _updateSorted();
    });
  }

  Future<void> _drawRandom() async {
    if (_isLotteryAnimating) return;
    setState(() => _isLotteryAnimating = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (_sortedTechniques.isEmpty) return;
    final pick = _sortedTechniques[
        DateTime.now().millisecondsSinceEpoch % _sortedTechniques.length];
    setState(() {
      _lotteryResult = pick;
      _isLotteryAnimating = false;
    });
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ReflectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topThree = _sortedTechniques.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStrengthSection(context),
                    const SizedBox(height: 22),
                    _buildRecommendSection(context, topThree),
                    const SizedBox(height: 16),
                    _buildLotteryButton(context),
                    const SizedBox(height: 12),
                    _buildMoreTechLink(context),
                    const SizedBox(height: 18),
                    _buildReframeSection(context),
                    const SizedBox(height: 18),
                    _buildSuccessButton(context),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '渴望来袭？',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(kColorTextPrimary),
                letterSpacing: -0.4,
                height: 1.2,
              ),
            ),
          ),
          _iconBtn(
            Icons.close,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, {required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: const Color(kColorTextPrimary)),
        ),
      ),
    );
  }

  Widget _buildStrengthSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '先告诉我，此刻的强度',
          style: AppTheme.monoLabel(
            color: const Color(kColorTextHint),
            fontSize: 11,
          ).copyWith(letterSpacing: 0.16),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '微弱',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(kColorTextSecondary),
              ),
            ),
            Text(
              '强烈',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(kColorTextSecondary),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(kColorPrimary),
            inactiveTrackColor: const Color(kColorBorder),
            thumbColor: const Color(kColorPrimary),
            overlayColor: const Color(kColorPrimary).withAlpha(38),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
            ),
          ),
          child: Slider(
            value: _urgeLevel.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (v) => _onLevelChanged(v.round()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '$_urgeLevel',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: const Color(kColorPrimary),
                letterSpacing: -0.5,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              _urgencyLabel(_urgeLevel),
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(kColorTextSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendSection(
      BuildContext context, List<UrgeTechnique> techs) {
    if (techs.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '在此强度下，这些会有效',
          style: AppTheme.monoLabel(
            color: const Color(kColorTextHint),
            fontSize: 11,
          ).copyWith(letterSpacing: 0.16),
        ),
        const SizedBox(height: 12),
        ...techs.asMap().entries.map((entry) {
          final i = entry.key;
          final tech = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildTechCard(tech, i == 0),
          );
        }),
      ],
    );
  }

  Widget _buildTechCard(UrgeTechnique tech, bool isTop) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateToTechnique(tech),
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(kColorSurface),
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(color: const Color(kColorBorderSoft)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _pill(isTop ? '最优先' : '高优先', isTop),
                  Text(
                    '${tech.durationSeconds} 秒 · ${tech.keyMechanism}',
                    style: AppTheme.monoLabel(
                      color: const Color(kColorTextHint),
                      fontSize: 11,
                    ).copyWith(letterSpacing: 0.04),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'T${tech.id.substring(1)} · ${tech.name}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(kColorTextPrimary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getTechDescription(tech),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(kColorTextSecondary),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTechDescription(UrgeTechnique tech) {
    if (tech.id == 'T11') return '物理冷激活先于认知干预。冷洗后半段是对着镜子说三句话。';
    if (tech.id == 'T4') return '呼气延长 → 副交感神经激活，刚好覆盖一个完整渴望周期。';
    if (tech.id == 'T5') return '说出 5 件看见的、4 件能触摸的、3 件能听到的……把前额叶请回来。';
    return tech.instruction.split('\n').first;
  }

  Widget _pill(String label, bool warm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: warm
            ? const Color(kColorWarning).withAlpha(31)
            : const Color(kColorSurfaceWarm),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: warm
              ? const Color(kColorWarning)
              : const Color(kColorTextSecondary),
        ),
      ),
    );
  }

  Widget _buildLotteryButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLotteryAnimating ? null : _drawRandom,
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(
              color: const Color(kColorBorder),
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(kColorSurfaceWarm),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: _isLotteryAnimating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(kColorPrimary),
                        ),
                      )
                    : const Icon(
                        Icons.shuffle,
                        size: 18,
                        color: Color(kColorTextPrimary),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lotteryResult != null
                          ? 'T${_lotteryResult!.id.substring(1)} · ${_lotteryResult!.name}'
                          : '随机抽卡',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(kColorTextPrimary),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _lotteryResult != null
                          ? '已抽到，试试这个'
                          : '选不出来？让系统替你翻一张。',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(kColorTextHint),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 16,
                color: Color(kColorTextHint),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreTechLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => setState(() => _showAll = !_showAll),
        style: TextButton.styleFrom(
          foregroundColor: const Color(kColorPrimary),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          _showAll ? '收起 ▴' : '查看全部 11 种技术 ▾',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildReframeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '写下此刻的想法（可选）',
          style: AppTheme.monoLabel(
            color: const Color(kColorTextHint),
            fontSize: 11,
          ).copyWith(letterSpacing: 0.16),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(kColorSurface),
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(color: const Color(kColorBorderSoft)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"晚上 11 点，很累，刚下班到家……"',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: const Color(kColorTextPrimary),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '已自动加密 · 仅你可见',
                    style: AppTheme.monoLabel(
                      color: const Color(kColorTextHint),
                      fontSize: 11,
                    ).copyWith(letterSpacing: 0.04),
                  ),
                  Text(
                    '继续 ▸',
                    style: AppTheme.tabularNum(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(kColorPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _onSuccess,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(kColorSuccess),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadiusPill),
          ),
        ),
        icon: const Icon(Icons.check, size: 18),
        label: Text(
          '成功应对 · 记录这次',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}