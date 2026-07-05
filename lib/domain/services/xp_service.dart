import '../../core/constants/app_constants.dart';

/// XP rewards for various actions
class XPService {
  /// Calculate XP earned for daily activity
  static int calculateDailyXP({
    required bool didCheckIn,
    required int urgesResisted,
    required int techniquesCompleted,
    required bool wroteJournal,
    required bool recordedMood,
  }) {
    int xp = 0;
    if (didCheckIn) xp += kXPDailyCheckIn;
    xp += urgesResisted * kXPUrgeResisted;
    xp += techniquesCompleted * kXPTechniqueComplete;
    if (wroteJournal) xp += kXPJournalEntry;
    if (recordedMood) xp += 10;
    return xp;
  }

  /// XP for streak milestones (applied on the day the milestone is reached)
  static int streakBonus(int days) {
    if (days == 7) return kXPStreak7Day;
    if (days == 30) return kXPStreak30Day;
    if (days == 90) return 3000;
    if (days == 180) return 5000;
    if (days == 365) return 10000;
    return 0;
  }

  /// Quick XP for a single urge resisted
  static int get urgeResisted => kXPUrgeResisted;
  static int get techniqueComplete => kXPTechniqueComplete;
  static int get journalEntry => kXPJournalEntry;
  static int get triggerLog => kXPTriggerLog;
}