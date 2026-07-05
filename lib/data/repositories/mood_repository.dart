import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/mood_entry.dart';

/// MoodRepository - Persists mood entries via SharedPreferences
class MoodRepository {
  static const _key = kStorageMoodEntries;

  Future<List<MoodEntry>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) {
      try {
        return MoodEntry.fromJson(jsonDecode(s) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<MoodEntry>().toList();
  }

  Future<void> save(MoodEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadAll();
    // Replace existing entry for the same day
    entries.removeWhere((e) =>
        e.date.year == entry.date.year &&
        e.date.month == entry.date.month &&
        e.date.day == entry.date.day);
    entries.add(entry);
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  Future<void> deleteForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadAll();
    entries.removeWhere((e) =>
        e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day);
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  Future<MoodEntry?> getForDate(DateTime date) async {
    final entries = await loadAll();
    for (final e in entries) {
      if (e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day) {
        return e;
      }
    }
    return null;
  }
}