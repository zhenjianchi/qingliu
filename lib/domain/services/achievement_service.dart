import 'package:flutter/material.dart';
import '../entities/achievement.dart';

/// AchievementService - Manages achievement definitions and unlocks
class AchievementService {
  /// Get all achievement templates
  static List<Achievement> getAllAchievements() {
    return [
      // Persistence 坚持类
      const Achievement(
        id: 'day_1',
        name: '启程',
        description: '完成第1天',
        category: AchievementCategory.persistence,
        icon: Icons.flag,
        color: Color(0xFF58CC02),
        requirementDays: 1,
      ),
      const Achievement(
        id: 'day_3',
        name: '三日决心',
        description: '连续3天',
        category: AchievementCategory.persistence,
        icon: Icons.eco,
        color: Color(0xFF7BE325),
        requirementDays: 3,
      ),
      const Achievement(
        id: 'day_7',
        name: '一周坚持',
        description: '连续7天',
        category: AchievementCategory.persistence,
        icon: Icons.local_fire_department,
        color: Color(0xFFFF8C42),
        requirementDays: 7,
      ),
      const Achievement(
        id: 'day_14',
        name: '双周蜕变',
        description: '连续14天',
        category: AchievementCategory.persistence,
        icon: Icons.energy_savings_leaf,
        color: Color(0xFFCE82FF),
        requirementDays: 14,
      ),
      const Achievement(
        id: 'day_30',
        name: '月度勇士',
        description: '连续30天',
        category: AchievementCategory.persistence,
        icon: Icons.workspace_premium,
        color: Color(0xFFFFC800),
        requirementDays: 30,
      ),
      const Achievement(
        id: 'day_90',
        name: '季度大师',
        description: '连续90天',
        category: AchievementCategory.persistence,
        icon: Icons.emoji_events,
        color: Color(0xFFFF4B4B),
        requirementDays: 90,
      ),

      // Response 应对类
      const Achievement(
        id: 'first_response',
        name: '首次应对',
        description: '成功应对第一次渴望',
        category: AchievementCategory.response,
        icon: Icons.shield,
        color: Color(0xFF58CC02),
      ),
      const Achievement(
        id: 'response_10',
        name: '十战老兵',
        description: '成功应对10次',
        category: AchievementCategory.response,
        icon: Icons.security,
        color: Color(0xFF5B6CFF),
      ),
      const Achievement(
        id: 'response_50',
        name: '五十勇士',
        description: '成功应对50次',
        category: AchievementCategory.response,
        icon: Icons.military_tech,
        color: Color(0xFFFFC800),
      ),
      const Achievement(
        id: 'response_100',
        name: '百战英雄',
        description: '成功应对100次',
        category: AchievementCategory.response,
        icon: Icons.workspace_premium,
        color: Color(0xFFCE82FF),
      ),

      // Reflection 反思类
      const Achievement(
        id: 'first_journal',
        name: '第一篇日记',
        description: '写下第一篇反思',
        category: AchievementCategory.reflection,
        icon: Icons.edit_note,
        color: Color(0xFFCE82FF),
      ),
      const Achievement(
        id: 'mood_7days',
        name: '心情观察家',
        description: '连续7天记录心情',
        category: AchievementCategory.reflection,
        icon: Icons.mood,
        color: Color(0xFFFFC800),
      ),

      // Learning 学习类
      const Achievement(
        id: 'first_technique',
        name: '技巧学徒',
        description: '完成第一个技巧',
        category: AchievementCategory.learning,
        icon: Icons.school,
        color: Color(0xFF58CC02),
      ),
      const Achievement(
        id: 'all_techniques',
        name: '技巧通',
        description: '尝试所有应对技巧',
        category: AchievementCategory.learning,
        icon: Icons.psychology,
        color: Color(0xFF5B6CFF),
      ),

      // Special 特殊类
      const Achievement(
        id: 'level_5',
        name: '初出茅庐',
        description: '达到 Lv 5',
        category: AchievementCategory.special,
        icon: Icons.star,
        color: Color(0xFFCE82FF),
      ),
      const Achievement(
        id: 'level_10',
        name: '觉醒战士',
        description: '达到 Lv 10',
        category: AchievementCategory.special,
        icon: Icons.auto_awesome,
        color: Color(0xFFFFC800),
      ),
    ];
  }

  /// Check which achievements should be unlocked based on stats
  static List<Achievement> checkUnlocks({
    required List<Achievement> current,
    required int currentStreakDays,
    required int totalUrgesResisted,
    required int totalTechniquesUsed,
    required int totalJournalEntries,
    required int totalMoodEntries,
    required int currentLevel,
  }) {
    final updated = <Achievement>[];
    for (final ach in current) {
      bool shouldUnlock = ach.unlocked;
      DateTime? unlockedAt = ach.unlockedAt;

      if (!shouldUnlock) {
        final meetsRequirement = _checkRequirement(
          ach,
          currentStreakDays: currentStreakDays,
          totalUrgesResisted: totalUrgesResisted,
          totalTechniquesUsed: totalTechniquesUsed,
          totalJournalEntries: totalJournalEntries,
          totalMoodEntries: totalMoodEntries,
          currentLevel: currentLevel,
        );
        if (meetsRequirement) {
          shouldUnlock = true;
          unlockedAt = DateTime.now();
        }
      }

      updated.add(ach.copyWith(
        unlocked: shouldUnlock,
        unlockedAt: unlockedAt,
      ));
    }
    return updated;
  }

  static bool _checkRequirement(
    Achievement ach, {
    required int currentStreakDays,
    required int totalUrgesResisted,
    required int totalTechniquesUsed,
    required int totalJournalEntries,
    required int totalMoodEntries,
    required int currentLevel,
  }) {
    // Day-based persistence
    if (ach.requirementDays != null && ach.category == AchievementCategory.persistence) {
      return currentStreakDays >= ach.requirementDays!;
    }

    // Response counts
    if (ach.id == 'first_response') return totalUrgesResisted >= 1;
    if (ach.id == 'response_10') return totalUrgesResisted >= 10;
    if (ach.id == 'response_50') return totalUrgesResisted >= 50;
    if (ach.id == 'response_100') return totalUrgesResisted >= 100;

    // Reflection
    if (ach.id == 'first_journal') return totalJournalEntries >= 1;
    if (ach.id == 'mood_7days') return totalMoodEntries >= 7;

    // Learning
    if (ach.id == 'first_technique') return totalTechniquesUsed >= 1;
    if (ach.id == 'all_techniques') return totalTechniquesUsed >= 11;

    // Special - level based
    if (ach.id == 'level_5') return currentLevel >= 5;
    if (ach.id == 'level_10') return currentLevel >= 10;

    return false;
  }
}