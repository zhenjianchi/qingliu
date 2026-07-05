import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';

/// SQLite data source for all app data
/// All tables are local-only, no cloud sync
/// On web: falls back to in-memory stub (sqflite not supported)
class LocalDataSource {
  static LocalDataSource? _instance;
  static LocalDataSource get instance => _instance ??= LocalDataSource._();

  LocalDataSource._();

  Database? _db;
  final AppLogger _logger = AppLogger.instance;
  bool _isWeb = false;

  Future<void> init() async {
    if (_db != null) return;

    _isWeb = kIsWeb;
    if (_isWeb) {
      _logger.info('Running on web - using in-memory data stub',
          tag: 'LocalDataSource');
      return;
    }

    try {
      final dbPath = path.join(
        await getDatabasesPath(),
        kStorageDbName,
      );

      _db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE abstinence_records (
              id TEXT PRIMARY KEY,
              start_time TEXT NOT NULL,
              end_time TEXT,
              goal_days INTEGER NOT NULL,
              is_active INTEGER NOT NULL DEFAULT 1
            )
          ''');

          await db.execute('''
            CREATE TABLE trigger_logs (
              id TEXT PRIMARY KEY,
              timestamp TEXT NOT NULL,
              emotion TEXT NOT NULL,
              urge_level INTEGER NOT NULL,
              note TEXT,
              location TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE urge_logs (
              id TEXT PRIMARY KEY,
              timestamp TEXT NOT NULL,
              urge_level_before INTEGER NOT NULL,
              technique_id TEXT NOT NULL,
              completed INTEGER NOT NULL,
              duration_seconds INTEGER NOT NULL,
              trigger_log_id TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE milestone_achievements (
              id TEXT PRIMARY KEY,
              target_days INTEGER NOT NULL,
              achieved_at TEXT NOT NULL,
              name TEXT NOT NULL,
              emoji TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE settings (
              key TEXT PRIMARY KEY,
              value TEXT NOT NULL
            )
          ''');

          _logger.info('Database tables created', tag: 'LocalDataSource');
        },
      );
    } catch (e, st) {
      _logger.error('Failed to init database', error: e, stackTrace: st);
    }
  }

  Future<Map<String, dynamic>?> getActiveAbstinenceRecord() async {
    if (_isWeb || _db == null) return null;
    final rows = await _db!.query(
      'abstinence_records',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'start_time DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> insertAbstinenceRecord(Map<String, dynamic> record) async {
    if (_isWeb || _db == null) return;
    await _db!.insert('abstinence_records', record);
  }

  Future<List<Map<String, dynamic>>> getAbstinenceRecords() async {
    if (_isWeb || _db == null) return [];
    return _db!.query('abstinence_records', orderBy: 'start_time DESC');
  }

  Future<void> endAbstinenceRecord(String id, DateTime endTime) async {
    if (_isWeb || _db == null) return;
    await _db!.update(
      'abstinence_records',
      {
        'is_active': 0,
        'end_time': endTime.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateAbstinenceRecord(
      String id, Map<String, dynamic> updates) async {
    if (_isWeb || _db == null) return;
    await _db!.update(
      'abstinence_records',
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllData() async {
    if (_isWeb || _db == null) return;
    await _db!.delete('abstinence_records');
    await _db!.delete('trigger_logs');
    await _db!.delete('urge_logs');
    await _db!.delete('milestone_achievements');
    await _db!.delete('settings');
  }

  Future<void> deleteAbstinenceRecord(String id) async {
    if (_isWeb || _db == null) return;
    await _db!.delete(
      'abstinence_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getTriggerLogs({int limit = 50}) async {
    if (_isWeb || _db == null) return [];
    return _db!.query(
      'trigger_logs',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }

  Future<void> insertTriggerLog(Map<String, dynamic> log) async {
    if (_isWeb || _db == null) return;
    await _db!.insert('trigger_logs', log);
  }

  Future<List<Map<String, dynamic>>> getUrgeLogs({int limit = 50}) async {
    if (_isWeb || _db == null) return [];
    return _db!.query(
      'urge_logs',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }

  Future<void> insertUrgeLog(Map<String, dynamic> log) async {
    if (_isWeb || _db == null) return;
    await _db!.insert('urge_logs', log);
  }

  Future<List<Map<String, dynamic>>> getMilestones() async {
    if (_isWeb || _db == null) return [];
    return _db!.query('milestone_achievements', orderBy: 'target_days ASC');
  }

  Future<void> insertMilestone(Map<String, dynamic> milestone) async {
    if (_isWeb || _db == null) return;
    await _db!.insert(
      'milestone_achievements',
      milestone,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<String?> getSetting(String key) async {
    if (_isWeb || _db == null) return null;
    final rows = await _db!.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<void> setSetting(String key, String value) async {
    if (_isWeb || _db == null) return;
    await _db!.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}