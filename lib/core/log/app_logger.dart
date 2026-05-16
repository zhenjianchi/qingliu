import 'dart:io';
import 'package:path/path.dart' as path;

/// Simple file-based logger for 清流
/// Logs to app_documents_dir/logs/qingliu_{date}.log
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._();

  AppLogger._();

  File? _logFile;
  final StringBuffer _buffer = StringBuffer();
  bool _initialized = false;

  String _logFilePath = '';

  /// Initialize logger. Call once at app startup.
  Future<void> init({String? logDirectory}) async {
    if (_initialized) return;

    final now = DateTime.now();
    final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final logDir = logDirectory ?? path.join(Directory.current.path, 'logs');

    await Directory(logDir).create(recursive: true);
    _logFilePath = path.join(logDir, 'qingliu_$dateStr.log');

    _logFile = File(_logFilePath);
    await _logFile!.writeAsString('', flush: true);

    _initialized = true;
    await _flush();

    info('AppLogger initialized. Log file: $_logFilePath');
  }

  void _log(String level, String tag, String message, [Object? error, StackTrace? stackTrace]) {
    final now = DateTime.now();
    final ts = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
             '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final buf = StringBuffer();
    buf.write('[$ts][$level][$tag] $message');
    if (error != null) {
      buf.write(' | error: $error');
    }
    if (stackTrace != null) {
      buf.write(' | stack: ${stackTrace.toString().replaceAll('\n', ' ')}');
    }

    final line = buf.toString();
    _buffer.writeln(line);

    // Also print to stdout for debug builds
    print(line);
  }

  void info(String message, {String tag = 'INFO'}) => _log('INFO', tag, message);
  void debug(String message, {String tag = 'DEBUG'}) => _log('DEBUG', tag, message);
  void warning(String message, {String tag = 'WARN'}) => _log('WARN', tag, message);

  void error(String message, {Object? error, StackTrace? stackTrace, String tag = 'ERROR'}) {
    _log('ERROR', tag, message, error, stackTrace);
    _flush();
  }

  Future<void> _flush() async {
    if (_logFile == null || _buffer.isEmpty) return;

    try {
      await _logFile!.writeAsString(_buffer.toString(), mode: FileMode.append, flush: true);
      _buffer.clear();
    } catch (e) {
      print('AppLogger flush failed: $e');
    }
  }

  /// Force flush buffer to file
  Future<void> flush() => _flush();

  /// Get path to current log file
  String get logFilePath => _logFilePath;
}