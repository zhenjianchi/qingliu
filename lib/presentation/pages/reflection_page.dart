import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// V3.0 Post-Relapse Reflection (学习而不是归零)
/// 参考: doc/design/20260705/HTML/mobile-ios.html (Screen 04)
///
/// - "那一刻，你试过哪些东西？" 问卷
/// - Multi-select chips
/// - "破戒不是失败" 鼓励
/// - Progress + step indicator
class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  int _step = 2; // 0..4 (5 questions)
  final Set<String> _selected = {};

  final List<_Question> _questions = const [
    _Question(
      text: '那一刻，你试过哪些东西？',
      hint: '慢慢来 · 你想到什么就选什么 · 哪怕只是"我没应对"也算数',
      options: [
        _Option('90 秒呼吸法 (T4)', icon: Icons.air),
        _Option('冷水洗脸', icon: Icons.water_drop),
        _Option('感官接地 54321 (T5)', icon: Icons.visibility),
        _Option('20 个深蹲', icon: Icons.fitness_center),
        _Option('找 AI 聊了一会', icon: Icons.chat_bubble_outline),
        _Option('没有特别应对', icon: Icons.do_not_disturb),
      ],
    ),
    _Question(
      text: '那时候你的状态是什么？',
      hint: '选最接近的就好 · 不必精准',
      options: [
        _Option('疲惫'),
        _Option('无聊'),
        _Option('焦虑'),
        _Option('孤独'),
        _Option('刚下班到家'),
        _Option('睡前'),
      ],
    ),
    _Question(
      text: '这一次里，你学到了什么？',
      hint: '哪怕只是一件小事',
      options: [
        _Option('某个时间点特别容易'),
        _Option('某个场景特别危险'),
        _Option('某句话会触发'),
        _Option('某个工具有效'),
        _Option('需要更早求助'),
        _Option('还没想清楚'),
      ],
    ),
  ];

  void _toggleOption(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  void _next() {
    if (_step < 4) {
      setState(() {
        _step++;
        _selected.clear();
      });
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_step > 0) {
      setState(() {
        _step--;
        _selected.clear();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  void _finish() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(kColorBackground),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadiusLarge),
        ),
        title: Text(
          '记录完成',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '这次记录会成为你下一篇笔记。你的 23 天累计保留不变 —— 破戒≠失败。',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
            color: const Color(kColorTextSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(kColorPrimary),
            ),
            child: const Text('继续'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_step.clamp(0, _questions.length - 1)];
    final progress = (_step + 1) / 5;

    return Scaffold(
      backgroundColor: const Color(kColorBackground),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildProgress(progress),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.text,
                      style: GoogleFonts.inter(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: const Color(kColorTextPrimary),
                        height: 1.25,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.hint,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(kColorTextSecondary),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...q.options.map((opt) {
                      final isSelected = _selected.contains(opt.label);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _optionChip(opt, isSelected),
                      );
                    }),
                    const SizedBox(height: 18),
                    _buildEncouragement(),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
            _buildFooter(),
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
              '让我们理解这次发生了什么',
              style: AppTheme.monoLabel(
                color: const Color(kColorTextHint),
                fontSize: 11,
              ).copyWith(letterSpacing: 0.16),
            ),
          ),
          _iconBtn(Icons.close, () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
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

  Widget _buildProgress(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '第 ${_step + 1} / 5 题 · 约 2 分钟',
                style: AppTheme.monoLabel(
                  color: const Color(kColorTextHint),
                  fontSize: 11,
                ).copyWith(letterSpacing: 0.08),
              ),
              Text(
                '已保留 · 23 天累计',
                style: AppTheme.tabularNum(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(kColorPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: const Color(kColorSurface),
              valueColor: const AlwaysStoppedAnimation(Color(kColorPrimary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionChip(_Option opt, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleOption(opt.label),
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(kColorPrimary).withAlpha(26)
                : const Color(kColorSurface),
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(
              color: isSelected
                  ? const Color(kColorPrimary)
                  : const Color(kColorBorder),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              if (opt.icon != null) ...[
                Icon(
                  opt.icon,
                  size: 16,
                  color: isSelected
                      ? const Color(kColorPrimary)
                      : const Color(kColorTextSecondary),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  opt.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? const Color(kColorPrimary)
                        : const Color(kColorTextPrimary),
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check,
                  size: 18,
                  color: Color(kColorPrimary),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEncouragement() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(kColorSurfaceWarm),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '破戒不是失败 —— 它只是还没写完的笔记。每一次都让你更清楚下次能做的微调。',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(kColorTextSecondary),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(kColorBorderSoft),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: _prev,
              style: TextButton.styleFrom(
                foregroundColor: const Color(kColorTextSecondary),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  side: const BorderSide(color: Color(kColorBorder)),
                ),
              ),
              child: Text(
                _step == 0 ? '取消' : '上一步',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(kColorPrimary),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
              ),
              child: Text(
                _step == 4 ? '完成' : '继续 →',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Question {
  final String text;
  final String hint;
  final List<_Option> options;

  const _Question({
    required this.text,
    required this.hint,
    required this.options,
  });
}

class _Option {
  final String label;
  final IconData? icon;

  const _Option(this.label, {this.icon});
}