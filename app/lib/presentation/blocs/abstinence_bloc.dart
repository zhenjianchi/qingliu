import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/abstinence_record.dart';
import '../../../data/datasources/local_datasource.dart';
import '../../../core/log/app_logger.dart';
import 'package:uuid/uuid.dart';

// ============ Events ============
abstract class AbstinenceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AbstinenceLoadRequested extends AbstinenceEvent {}
class AbstinenceStarted extends AbstinenceEvent {
  final int goalDays;
  AbstinenceStarted({required this.goalDays});
  @override
  List<Object?> get props => [goalDays];
}
class AbstinenceRelapsed extends AbstinenceEvent {
  final String? reason;
  AbstinenceRelapsed({this.reason});
  @override
  List<Object?> get props => [reason];
}
class AbstinenceTicked extends AbstinenceEvent {}
class AbstinenceGoalUpdated extends AbstinenceEvent {
  final int newGoalDays;
  AbstinenceGoalUpdated({required this.newGoalDays});
  @override
  List<Object?> get props => [newGoalDays];
}
class AbstinenceRecordDeleted extends AbstinenceEvent {}

// ============ States ============
abstract class AbstinenceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AbstinenceInitial extends AbstinenceState {}

class AbstinenceLoading extends AbstinenceState {}

class AbstinenceNoRecord extends AbstinenceState {}

class AbstinenceActive extends AbstinenceState {
  final AbstinenceRecord record;
  final Duration elapsed;
  final int nextMilestoneDays;
  final double milestoneProgress;

  AbstinenceActive({
    required this.record,
    required this.elapsed,
    required this.nextMilestoneDays,
    required this.milestoneProgress,
  });

  @override
  List<Object?> get props => [record, elapsed, nextMilestoneDays, milestoneProgress];
}

class AbstinenceJustRelapsed extends AbstinenceState {
  final AbstinenceRecord previousRecord;
  final int previousDays;
  AbstinenceJustRelapsed({required this.previousRecord, required this.previousDays});
  @override
  List<Object?> get props => [previousRecord, previousDays];
}

class AbstinenceError extends AbstinenceState {
  final String message;
  AbstinenceError(this.message);
  @override
  List<Object?> get props => [message];
}

// ============ BLoC ============
class AbstinenceBloc extends Bloc<AbstinenceEvent, AbstinenceState> {
  final LocalDataSource _dataSource;
  final AppLogger _logger = AppLogger.instance;
  final _uuid = const Uuid();

  AbstinenceBloc({LocalDataSource? dataSource})
    : _dataSource = dataSource ?? LocalDataSource.instance,
      super(AbstinenceInitial()) {
    on<AbstinenceLoadRequested>(_onLoad);
    on<AbstinenceStarted>(_onStart);
    on<AbstinenceRelapsed>(_onRelapsed);
    on<AbstinenceTicked>(_onTicked);
    on<AbstinenceGoalUpdated>(_onGoalUpdated);
  }

  Future<void> _onLoad(AbstinenceLoadRequested event, Emitter<AbstinenceState> emit) async {
    emit(AbstinenceLoading());
    try {
      final recordMap = await _dataSource.getActiveAbstinenceRecord();
      if (recordMap == null) {
        emit(AbstinenceNoRecord());
        return;
      }
      final record = _mapToRecord(recordMap);
      emit(_makeActiveState(record));
    } catch (e, st) {
      _logger.error('Failed to load abstinence record', error: e, stackTrace: st);
      emit(AbstinenceError(e.toString()));
    }
  }

  Future<void> _onStart(AbstinenceStarted event, Emitter<AbstinenceState> emit) async {
    try {
      final record = AbstinenceRecord(
        id: _uuid.v4(),
        startTime: DateTime.now(),
        goalDays: event.goalDays,
        isActive: true,
      );
      await _dataSource.insertAbstinenceRecord(_recordToMap(record));
      _logger.info('Abstinence started: goal=${event.goalDays} days', tag: 'AbstinenceBloc');
      emit(_makeActiveState(record));
    } catch (e, st) {
      _logger.error('Failed to start abstinence', error: e, stackTrace: st);
      emit(AbstinenceError(e.toString()));
    }
  }

  Future<void> _onRelapsed(AbstinenceRelapsed event, Emitter<AbstinenceState> emit) async {
    final currentState = state;
    if (currentState is! AbstinenceActive) return;

    try {
      final previousRecord = currentState.record;
      final previousDays = previousRecord.days;

      // Mark current record as ended
      final endedRecord = previousRecord.copyWith(
        endTime: DateTime.now(),
        isActive: false,
      );
      await _dataSource.updateAbstinenceRecord(
        previousRecord.id,
        _recordToMap(endedRecord),
      );

      _logger.info('Abstinence relapsed: ${previousDays} days, reason=${event.reason}', tag: 'AbstinenceBloc');
      emit(AbstinenceJustRelapsed(previousRecord: previousRecord, previousDays: previousDays));
    } catch (e, st) {
      _logger.error('Failed to record relapse', error: e, stackTrace: st);
      emit(AbstinenceError(e.toString()));
    }
  }

  Future<void> _onTicked(AbstinenceTicked event, Emitter<AbstinenceState> emit) async {
    final currentState = state;
    if (currentState is! AbstinenceActive) return;

    try {
      final recordMap = await _dataSource.getActiveAbstinenceRecord();
      if (recordMap == null) {
        emit(AbstinenceNoRecord());
        return;
      }
      final record = _mapToRecord(recordMap);
      emit(_makeActiveState(record));
    } catch (e, st) {
      _logger.error('Failed to tick abstinence', error: e, stackTrace: st);
    }
  }

  Future<void> _onGoalUpdated(AbstinenceGoalUpdated event, Emitter<AbstinenceState> emit) async {
    final currentState = state;
    if (currentState is! AbstinenceActive) return;

    try {
      final updatedRecord = currentState.record.copyWith(goalDays: event.newGoalDays);
      await _dataSource.updateAbstinenceRecord(
        updatedRecord.id,
        _recordToMap(updatedRecord),
      );
      emit(_makeActiveState(updatedRecord));
    } catch (e, st) {
      _logger.error('Failed to update goal', error: e, stackTrace: st);
      emit(AbstinenceError(e.toString()));
    }
  }

  AbstinenceActive _makeActiveState(AbstinenceRecord record) {
    final elapsed = DateTime.now().difference(record.startTime);
    // Find next milestone
    const milestones = [7, 14, 30, 60, 90, 180, 365];
    int nextMilestone = milestones.firstWhere(
      (m) => m > record.days,
      orElse: () => 365,
    );
    int prevMilestone = 0;
    for (int m in milestones) {
      if (m <= record.days) prevMilestone = m;
    }
    double milestoneProgress = 0.0;
    if (nextMilestone > record.days) {
      int range = nextMilestone - prevMilestone;
      int progress = record.days - prevMilestone;
      milestoneProgress = (progress / range).clamp(0.0, 1.0);
    } else {
      milestoneProgress = 1.0;
    }

    return AbstinenceActive(
      record: record,
      elapsed: elapsed,
      nextMilestoneDays: nextMilestone,
      milestoneProgress: milestoneProgress,
    );
  }

  AbstinenceRecord _mapToRecord(Map<String, dynamic> map) => AbstinenceRecord(
    id: map['id'] as String,
    startTime: DateTime.parse(map['start_time'] as String),
    endTime: map['end_time'] != null ? DateTime.parse(map['end_time'] as String) : null,
    goalDays: map['goal_days'] as int,
    isActive: (map['is_active'] as int) == 1,
  );

  Map<String, dynamic> _recordToMap(AbstinenceRecord record) => {
    'id': record.id,
    'start_time': record.startTime.toIso8601String(),
    'end_time': record.endTime?.toIso8601String(),
    'goal_days': record.goalDays,
    'is_active': record.isActive ? 1 : 0,
  };
}