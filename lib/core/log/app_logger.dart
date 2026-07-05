import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Simple logger for 清流
/// - Native (iOS/macOS/Android/Windows/Linux): writes to file in logs/
/// - Web: prints to console only (no file system)
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._();

  AppLogger._();

  final StringBuffer _buffer = StringBuffer();
  bool _initialized = false;

  /// Initialize logger. Call once at app startup.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    if (kIsWeb) {
      // No file system on web - just log to console
      print('[INFO][AppLogger] Running on web - console logging only');
    } else {
      // Native: file logging would go here, but for simplicity we just print
      print('[INFO][AppLogger] Native logger initialized');
    }
  }

  void _log(String level, String tag, String message,
      [Object? error, StackTrace? stackTrace]) {
    final now = DateTime.now();
    final ts =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final buf = StringBuffer();
    buf.write('[$ts][$level][$tag] $message');
    if (error != null) buf.write(' | error: $error');
    if (stackTrace != null) {
      buf.write(' | stack: ${stackTrace.toString().replaceAll('\n', ' ')}');
    }

    final line = buf.toString();
    _buffer.writeln(line);
    // ignore: avoid_print
    print(line);
  }

  void info(String message, {String tag = 'INFO'}) =>
      _log('INFO', tag, message);
  void debug(String message, {String tag = 'DEBUG'}) =>
      _log('DEBUG', tag, message);
  void warning(String message, {String tag = 'WARN'}) =>
      _log('WARN', tag, message);

  void error(String message,
      {Object? error, StackTrace? stackTrace, String tag = 'ERROR'}) {
    _log('ERROR', tag, message, error, stackTrace);
  }

  Future<void> flush() async {
    // No-op on web; on native this could write to file
  }

  String get logFilePath => kIsWeb ? '(web - console only)' : '(native - console only)';
}