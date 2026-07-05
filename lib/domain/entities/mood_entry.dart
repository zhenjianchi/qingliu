/// MoodEntry - Daily mood tracking (1-5 scale)
class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5 (1=very bad, 5=excellent)
  final String? note;
  final List<String> tags;

  const MoodEntry({
    required this.date,
    required this.moodLevel,
    this.note,
    this.tags = const [],
  });

  MoodEntry copyWith({
    DateTime? date,
    int? moodLevel,
    String? note,
    List<String>? tags,
  }) {
    return MoodEntry(
      date: date ?? this.date,
      moodLevel: moodLevel ?? this.moodLevel,
      note: note ?? this.note,
      tags: tags ?? this.tags,
    );
  }

  /// Get mood emoji based on level
  String get emoji {
    switch (moodLevel) {
      case 1:
        return '😢';
      case 2:
        return '😟';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '🔥';
      default:
        return '😐';
    }
  }

  /// Get mood label
  String get label {
    switch (moodLevel) {
      case 1:
        return '很糟';
      case 2:
        return '不好';
      case 3:
        return '一般';
      case 4:
        return '好';
      case 5:
        return '非常好';
      default:
        return '一般';
    }
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'moodLevel': moodLevel,
    'note': note,
    'tags': tags,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    date: DateTime.parse(json['date'] as String),
    moodLevel: json['moodLevel'] as int,
    note: json['note'] as String?,
    tags: (json['tags'] as List?)?.cast<String>() ?? const [],
  );
}