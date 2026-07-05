import 'package:flutter/material.dart';

/// Achievement categories
enum AchievementCategory {
  persistence,  // 坚持类
  response,     // 应对类
  reflection,   // 反思类
  learning,     // 学习类
  special,      // 特殊类
}

extension AchievementCategoryX on AchievementCategory {
  String get label {
    switch (this) {
      case AchievementCategory.persistence:
        return '坚持';
      case AchievementCategory.response:
        return '应对';
      case AchievementCategory.reflection:
        return '反思';
      case AchievementCategory.learning:
        return '学习';
      case AchievementCategory.special:
        return '特殊';
    }
  }

  IconData get icon {
    switch (this) {
      case AchievementCategory.persistence:
        return Icons.local_fire_department;
      case AchievementCategory.response:
        return Icons.shield;
      case AchievementCategory.reflection:
        return Icons.edit_note;
      case AchievementCategory.learning:
        return Icons.school;
      case AchievementCategory.special:
        return Icons.star;
    }
  }
}

/// Achievement - Unlockable badge
class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final DateTime? unlockedAt;
  final int? requirementDays; // optional - days needed to unlock

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    this.unlocked = false,
    this.unlockedAt,
    this.requirementDays,
  });

  Achievement copyWith({
    bool? unlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      name: name,
      description: description,
      category: category,
      icon: icon,
      color: color,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requirementDays: requirementDays,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'unlocked': unlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

  factory Achievement.fromJson(Map<String, dynamic> json, Achievement template) {
    return template.copyWith(
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }
}