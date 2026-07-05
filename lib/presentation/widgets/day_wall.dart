import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';

/// Single day entry in the DayWall
class DayEntry {
  final DateTime date;
  final int moodLevel; // 1-5
  final bool hasRecord;
  final String? note;

  const DayEntry({
    required this.date,
    required this.moodLevel,
    this.hasRecord = false,
    this.note,
  });

  DayEntry copyWith({int? moodLevel, bool? hasRecord, String? note}) {
    return DayEntry(
      date: date,
      moodLevel: moodLevel ?? this.moodLevel,
      hasRecord: hasRecord ?? this.hasRecord,
      note: note ?? this.note,
    );
  }
}

/// DayWall - 30-day mood timeline as emoji cards
/// Replaces the boring calendar heatmap with an engaging emoji grid
class DayWall extends StatelessWidget {
  final List<DayEntry> entries;
  final ValueChanged<DayEntry>? onTap;
  final int columns;
  final double spacing;

  const DayWall({
    super.key,
    required this.entries,
    this.onTap,
    this.columns = kDayWallColumns,
    this.spacing = 8,
  });

  Color _moodColor(int level) {
    final idx = (level - 1).clamp(0, kMoodColors.length - 1);
    return Color(kMoodColors[idx]);
  }

  String _moodEmoji(int level) {
    final idx = (level - 1).clamp(0, kMoodEmojis.length - 1);
    return kMoodEmojis[idx];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 1,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final color = _moodColor(entry.moodLevel);
        return _DayCell(
          entry: entry,
          color: color,
          emoji: _moodEmoji(entry.moodLevel),
          onTap: onTap,
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  final DayEntry entry;
  final Color color;
  final String emoji;
  final ValueChanged<DayEntry>? onTap;

  const _DayCell({
    required this.entry,
    required this.color,
    required this.emoji,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = _isToday(entry.date);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap == null ? null : () => onTap!(entry),
        child: Container(
          decoration: BoxDecoration(
            color: color.withAlpha(40),
            borderRadius: BorderRadius.circular(12),
            border: entry.hasRecord || isToday
                ? Border.all(
                    color: entry.hasRecord ? color : const Color(kColorPrimary),
                    width: isToday && !entry.hasRecord ? 2.5 : 2,
                  )
                : Border.all(
                    color: color.withAlpha(60),
                    width: 1,
                  ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              if (isToday)
                Positioned(
                  top: 2,
                  right: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(kColorPrimary),
                    ),
                  ),
                ),
              if (entry.hasRecord)
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Text(
                    '${entry.date.day}',
                    style: GoogleFonts.nunito(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

/// DayWallMoodPicker - Interactive mood selector (1-5)
class DayWallMoodPicker extends StatelessWidget {
  final int selectedLevel;
  final ValueChanged<int> onLevelChanged;

  const DayWallMoodPicker({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (i) {
        final level = i + 1;
        final isSelected = level == selectedLevel;
        final color = Color(kMoodColors[i]);
        return GestureDetector(
          onTap: () => onLevelChanged(level),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: isSelected ? 60 : 48,
            height: isSelected ? 60 : 48,
            decoration: BoxDecoration(
              color: isSelected ? color : color.withAlpha(40),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withAlpha(102),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                kMoodEmojis[i],
                style: TextStyle(fontSize: isSelected ? 32 : 24),
              ),
            ),
          ),
        );
      }),
    );
  }
}