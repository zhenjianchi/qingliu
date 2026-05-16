/// Trigger log entry entity
/// Records a triggering event when user feels urge coming on
class TriggerLog {
  final String id;
  final DateTime timestamp;
  final String emotion;   // from kTriggerEmotions list
  final int urgeLevel;    // 1-10
  final String? note;     // optional text note
  final String? location; // 'home' / 'dorm' / 'other'

  TriggerLog({
    required this.id,
    required this.timestamp,
    required this.emotion,
    required this.urgeLevel,
    this.note,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'emotion': emotion,
    'urgeLevel': urgeLevel,
    'note': note,
    'location': location,
  };

  factory TriggerLog.fromJson(Map<String, dynamic> json) => TriggerLog(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    emotion: json['emotion'] as String,
    urgeLevel: json['urgeLevel'] as int,
    note: json['note'] as String?,
    location: json['location'] as String?,
  );

  @override
  String toString() =>
    'TriggerLog(id: $id, emotion: $emotion, urgeLevel: $urgeLevel at $timestamp)';
}

/// Urge response log entry entity
/// Records each use of the urge response panel
class UrgeLog {
  final String id;
  final DateTime timestamp;
  final int urgeLevelBefore;  // 1-10
  final String techniqueId;    // T1-T11
  final bool completed;        // true = finished, false = gave up
  final int durationSeconds;   // actual time spent
  final String? triggerLogId;  // linked trigger log if any

  UrgeLog({
    required this.id,
    required this.timestamp,
    required this.urgeLevelBefore,
    required this.techniqueId,
    required this.completed,
    required this.durationSeconds,
    this.triggerLogId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'urgeLevelBefore': urgeLevelBefore,
    'techniqueId': techniqueId,
    'completed': completed,
    'durationSeconds': durationSeconds,
    'triggerLogId': triggerLogId,
  };

  factory UrgeLog.fromJson(Map<String, dynamic> json) => UrgeLog(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    urgeLevelBefore: json['urgeLevelBefore'] as int,
    techniqueId: json['techniqueId'] as String,
    completed: json['completed'] as bool,
    durationSeconds: json['durationSeconds'] as int,
    triggerLogId: json['triggerLogId'] as String?,
  );

  @override
  String toString() =>
    'UrgeLog(id: $id, technique: $techniqueId, completed: $completed)';
}

/// Milestone achievement entity
class MilestoneAchievement {
  final String id;
  final int targetDays;
  final DateTime achievedAt;
  final String name;
  final String emoji;

  MilestoneAchievement({
    required this.id,
    required this.targetDays,
    required this.achievedAt,
    required this.name,
    required this.emoji,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'targetDays': targetDays,
    'achievedAt': achievedAt.toIso8601String(),
    'name': name,
    'emoji': emoji,
  };

  factory MilestoneAchievement.fromJson(Map<String, dynamic> json) => MilestoneAchievement(
    id: json['id'] as String,
    targetDays: json['targetDays'] as int,
    achievedAt: DateTime.parse(json['achievedAt'] as String),
    name: json['name'] as String,
    emoji: json['emoji'] as String,
  );
}

/// Daily summary entity
class DailySummary {
  final DateTime date;
  final int abstinenceDays;
  final int triggerCount;
  final int urgeResponseCount;
  final int urgeResponseCompletedCount;
  final int avgUrgeLevel;
  final int moodScore;  // 1-5

  DailySummary({
    required this.date,
    required this.abstinenceDays,
    required this.triggerCount,
    required this.urgeResponseCount,
    required this.urgeResponseCompletedCount,
    required this.avgUrgeLevel,
    required this.moodScore,
  });

  /// Completion rate for urge responses
  double get completionRate =>
    urgeResponseCount > 0 ? urgeResponseCompletedCount / urgeResponseCount : 0.0;
}

/// Weekly report entity
class WeeklyReport {
  final DateTime weekStart;
  final int totalAbstinenceDays;
  final int previousWeekDays;  // for comparison
  final Map<String, int> triggerEmotionCounts;  // emotion -> count
  final int totalTriggers;
  final int urgeResponsesCompleted;
  final int urgeResponsesTotal;
  final List<MilestoneAchievement> milestonesAchieved;

  WeeklyReport({
    required this.weekStart,
    required this.totalAbstinenceDays,
    required this.previousWeekDays,
    required this.triggerEmotionCounts,
    required this.totalTriggers,
    required this.urgeResponsesCompleted,
    required this.urgeResponsesTotal,
    required this.milestonesAchieved,
  });

  double get improvementPercent =>
    previousWeekDays > 0 ? ((totalAbstinenceDays - previousWeekDays) / previousWeekDays * 100) : 0.0;

  String get topTriggerEmotion {
    if (triggerEmotionCounts.isEmpty) return '无';
    return triggerEmotionCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}