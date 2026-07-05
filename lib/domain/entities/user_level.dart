import '../../core/constants/app_constants.dart';

/// UserLevel - XP/Level progression system
class UserLevel {
  final int level;
  final int currentXP;
  final int nextLevelXP;
  final String title;

  const UserLevel({
    required this.level,
    required this.currentXP,
    required this.nextLevelXP,
    required this.title,
  });

  /// Progress to next level (0.0 - 1.0)
  double get progress => nextLevelXP > 0
      ? (currentXP / nextLevelXP).clamp(0.0, 1.0)
      : 0.0;

  /// Calculate level from total XP
  factory UserLevel.fromXP(int xp) {
    final thresholds = kLevelThresholds;
    final titles = kLevelTitles;

    int level = 1;
    for (int i = 1; i < thresholds.length; i++) {
      if (xp >= thresholds[i]) level = i + 1;
    }
    level = level.clamp(1, titles.length);

    final currentThreshold = thresholds[level - 1];
    final nextThreshold = level < thresholds.length
        ? thresholds[level]
        : thresholds.last + (level - thresholds.length + 1) * 1000;

    return UserLevel(
      level: level,
      currentXP: xp - currentThreshold,
      nextLevelXP: nextThreshold - currentThreshold,
      title: titles[level - 1],
    );
  }

  @override
  String toString() => 'Lv $level · $title ($currentXP/$nextLevelXP XP)';
}