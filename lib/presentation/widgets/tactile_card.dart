import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// TactileCard - 3D thick-border card with Duolingo/Lingo style
///
/// Uses a bottom shadow strip to create a "pressable" tactile feel.
/// Border color, thickness, and radius are all customizable.
class TactileCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool elevated;

  const TactileCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = kBorderRadiusLarge,
    this.borderWidth = 2.0,
    this.onTap,
    this.padding = const EdgeInsets.all(kPaddingLarge),
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surface;
    final isDark = theme.brightness == Brightness.dark;

    final defaultBorderColor = isDark
        ? const Color(0xFF3A3B4A)
        : const Color(0xFFEAEAEA);

    final effectiveBorder = borderColor ?? defaultBorderColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: effectiveBorder, width: borderWidth),
            boxShadow: elevated && onTap != null
                ? [
                    BoxShadow(
                      color: effectiveBorder.withAlpha(102),
                      blurRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// PressableCard - TactileCard with built-in press animation
class PressableCard extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const PressableCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.padding = const EdgeInsets.all(kPaddingLarge),
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scale = Tween(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: TactileCard(
          backgroundColor: widget.backgroundColor,
          borderColor: widget.borderColor,
          onTap: widget.onTap,
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}