import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';

/// Pill-shaped chip / tag (Lingo style)
class Pill extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double fontSize;

  const Pill({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? const Color(kColorPrimary);
    final fg = textColor ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(kBorderRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: fg, size: fontSize + 2),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.nunito(
              color: fg,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Big number with label (replaces progress ring)
class StepCounter extends StatelessWidget {
  final String number;
  final String label;
  final Color? color;
  final double numberSize;
  final String? suffix;
  final String? prefix;

  const StepCounter({
    super.key,
    required this.number,
    required this.label,
    this.color,
    this.numberSize = 96,
    this.suffix,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(kColorPrimary);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (prefix != null) ...[
              Text(
                prefix!,
                style: GoogleFonts.nunito(
                  fontSize: numberSize * 0.4,
                  fontWeight: FontWeight.w800,
                  color: c.withAlpha(180),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              number,
              style: GoogleFonts.nunito(
                fontSize: numberSize,
                fontWeight: FontWeight.w900,
                color: c,
                height: 1.0,
                letterSpacing: -2,
              ),
            ),
            if (suffix != null) ...[
              const SizedBox(width: 6),
              Text(
                suffix!,
                style: GoogleFonts.nunito(
                  fontSize: numberSize * 0.4,
                  fontWeight: FontWeight.w800,
                  color: c.withAlpha(180),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: c.withAlpha(180),
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

/// Level badge with 3D effect (Duolingo style)
class LevelBadge extends StatelessWidget {
  final int level;
  final String title;
  final double size;

  const LevelBadge({
    super.key,
    required this.level,
    this.title = 'LV',
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(kColorPrimary), Color(0xFF7BE325)],
        ),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(kColorPrimary).withAlpha(102),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            Text(
              '$level',
              style: GoogleFonts.nunito(
                fontSize: size * 0.4,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// XP bar with level/title
class XpBar extends StatelessWidget {
  final int currentXP;
  final int nextLevelXP;
  final String levelTitle;
  final Color? color;

  const XpBar({
    super.key,
    required this.currentXP,
    required this.nextLevelXP,
    required this.levelTitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(kColorPrimary);
    final progress = (currentXP / nextLevelXP).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              levelTitle,
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(kColorTextPrimary),
              ),
            ),
            Text(
              '$currentXP / $nextLevelXP XP',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(kColorTextSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(kColorSurfaceAlt),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [c, c.withAlpha(200)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Animated counter that ticks up to target value
class AnimatedCounter extends StatefulWidget {
  final int target;
  final int durationMs;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.target,
    this.durationMs = 1000,
    this.style,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMs),
    );
    _anim = Tween<double>(begin: 0, end: widget.target.toDouble()).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _anim.addListener(() {
      setState(() => _current = _anim.value.round());
    });
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _anim = Tween<double>(begin: _current.toDouble(), end: widget.target.toDouble())
          .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_current', style: widget.style);
  }
}