/// Abstinence record entity
/// Represents a single abstinence session from start to relapse
class AbstinenceRecord {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;  // null if currently active
  final int goalDays;
  final bool isActive;
  final int cumulativeDays; // Total days accumulated across all records (never reset on relapse)
  final int successfulResists; // Number of times user successfully resisted urges

  AbstinenceRecord({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.goalDays,
    required this.isActive,
    this.cumulativeDays = 0,
    this.successfulResists = 0,
  });

  /// Duration since start (or until end if ended)
  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Days rounded down
  int get days => duration.inDays;

  /// Total hours
  int get hours => duration.inHours;

  /// Remaining days to goal
  int get remainingDays => (goalDays - days).clamp(0, goalDays);

  /// Progress percentage (0.0 - 1.0)
  double get progress => (days / goalDays).clamp(0.0, 1.0);

  /// Whether goal has been reached
  bool get goalReached => days >= goalDays;

  /// Whether this session ended due to relapse
  bool get ended => endTime != null;

  /// Create a copy with updated fields
  AbstinenceRecord copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? goalDays,
    bool? isActive,
    int? cumulativeDays,
    int? successfulResists,
  }) {
    return AbstinenceRecord(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      goalDays: goalDays ?? this.goalDays,
      isActive: isActive ?? this.isActive,
      cumulativeDays: cumulativeDays ?? this.cumulativeDays,
      successfulResists: successfulResists ?? this.successfulResists,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'goalDays': goalDays,
    'isActive': isActive,
    'cumulativeDays': cumulativeDays,
    'successfulResists': successfulResists,
  };

  factory AbstinenceRecord.fromJson(Map<String, dynamic> json) => AbstinenceRecord(
    id: json['id'] as String,
    startTime: DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
    goalDays: json['goalDays'] as int,
    isActive: json['isActive'] as bool,
    cumulativeDays: json['cumulativeDays'] as int? ?? 0,
    successfulResists: json['successfulResists'] as int? ?? 0,
  );

  @override
  String toString() =>
    'AbstinenceRecord(id: $id, days: $days, goal: $goalDays, active: $isActive)';
}