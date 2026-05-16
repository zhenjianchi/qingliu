import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../../core/log/app_logger.dart';

/// SQLite data source for all app data
/// All tables are local-only, no cloud sync
class LocalDataSource {
  static LocalDataSource? _instance;
  static LocalDataSource get instance => _instance ??= LocalDataSource._();

  LocalDataSource._();

  Database? _db;
  final AppLogger _logger = AppLogger.instance;

  Future<void> init() async {
    if (_db != null) return;

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

    _logger.info('LocalDataSource initialized at $dbPath', tag: 'LocalDataSource');
  }

  // ============ Abstinence Records ============

  Future<void> insertAbstinenceRecord(Map<String, dynamic> record) async {
    await _db!.insert(
      'abstinence_records',
      record,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _logger.debug('Inserted abstinence record: ${record['id']}', tag: 'LocalDataSource');
  }

  Future<void> updateAbstinenceRecord(String id, Map<String, dynamic> record) async {
    await _db!.update(
      'abstinence_records',
      record,
      where: 'id = ?',
      whereArgs: [id],
    );
    _logger.debug('Updated abstinence record: $id', tag: 'LocalDataSource');
  }

  Future<List<Map<String, dynamic>>> getAbstinenceRecords() async {
    return await _db!.query(
      'abstinence_records',
      orderBy: 'start_time DESC',
    );
  }

  Future<Map<String, dynamic>?> getActiveAbstinenceRecord() async {
    final results = await _db!.query(
      'abstinence_records',
      where: 'is_active = ?',
      whereArgs: [1],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  // ============ Trigger Logs ============

  Future<void> insertTriggerLog(Map<String, dynamic> log) async {
    await _db!.insert(
      'trigger_logs',
      log,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTriggerLogs({int? limit}) async {
    return await _db!.query(
      'trigger_logs',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> getTriggerLogsInRange(DateTime start, DateTime end) async {
    return await _db!.query(
      'trigger_logs',
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
  }

  // ============ Urge Logs ============

  Future<void> insertUrgeLog(Map<String, dynamic> log) async {
    await _db!.insert(
      'urge_logs',
      log,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUrgeLogs({int? limit}) async {
    return await _db!.query(
      'urge_logs',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> getUrgeLogsInRange(DateTime start, DateTime end) async {
    return await _db!.query(
      'urge_logs',
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
  }

  // ============ Milestones ============

  Future<void> insertMilestone(Map<String, dynamic> milestone) async {
    await _db!.insert(
      'milestone_achievements',
      milestone,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMilestones() async {
    return await _db!.query(
      'milestone_achievements',
      orderBy: 'target_days ASC',
    );
  }

  Future<bool> hasMilestone(int targetDays) async {
    final results = await _db!.query(
      'milestone_achievements',
      where: 'target_days = ?',
      whereArgs: [targetDays],
    );
    return results.isNotEmpty;
  }

  // ============ Settings ============

  Future<void> setSetting(String key, String value) async {
    await _db!.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final results = await _db!.query(
      'settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    return results.isNotEmpty ? results.first['value'] as String : null;
  }

  // ============ Bulk Operations ============

  Future<void> clearAllData() async {
    await _db!.delete('abstinence_records');
    await _db!.delete('trigger_logs');
    await _db!.delete('urge_logs');
    await _db!.delete('milestone_achievements');
    // Keep settings
    _logger.warning('All data cleared', tag: 'LocalDataSource');
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
    _logger.info('LocalDataSource closed', tag: 'LocalDataSource');
  }
}