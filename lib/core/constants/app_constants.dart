/// App-wide constants for 清流 (Qingliu)
/// V2.0 - Lingo Design System palette
library;

/// App metadata
const String kAppName = '清流';
const String kAppNameEn = 'Qingliu';
const String kAppVersion = '2.0.0';
const int kBuildNumber = 2;

/// ============================================================================
/// Lingo Design System Color Palette
/// 参考: https://open-design.ai/plugins/design-system-lingo/
/// 核心理念：游戏化、活力、成长、年轻
/// ============================================================================

/// Primary - Duolingo Green (进步、活力、成长)
const int kColorPrimary = 0xFF58CC02;
const int kColorPrimaryDark = 0xFF46A601;
const int kColorPrimaryLight = 0xFFE9FAD9;

/// Secondary - Lavender Purple (平静、专注)
const int kColorSecondary = 0xFFCE82FF;
const int kColorSecondaryDark = 0xFFA65AE8;
const int kColorSecondaryLight = 0xFFF3E5FF;

/// Accent - Fresh Teal (保留作为过渡强调)
const int kColorAccent = 0xFF00D4AA;
const int kColorAccentDark = 0xFF00B894;
const int kColorAccentLight = 0xFFB8F4E0;

/// Warning - Bright Yellow (能量、提示)
const int kColorWarning = 0xFFFFC800;
const int kColorWarningDark = 0xFFE6B400;

/// Danger - Bright Red (警示、紧迫)
const int kColorDanger = 0xFFFF4B4B;
const int kColorError = 0xFFFF4B4B;

/// Info - Cool Blue (理性、科学)
const int kColorInfo = 0xFF5B6CFF;
const int kColorSuccess = 0xFF22A06B;

/// Background colors
const int kColorBackground = 0xFFFAFAFA;
const int kColorSurface = 0xFFFFFFFF;
const int kColorSurfaceAlt = 0xFFF7F7F7;

/// Text colors
const int kColorTextPrimary = 0xFF3C3C3C;
const int kColorTextSecondary = 0xFF6B6B6B;
const int kColorTextHint = 0xFF9CA3AF;
const int kColorTextOnPrimary = 0xFFFFFFFF;

/// Gradient definitions (Lingo inspired)
const List<int> kGradientPrimary = [0xFF58CC02, 0xFF7BE325];
const List<int> kGradientAccent = [0xFFCE82FF, 0xFFA65AE8];
const List<int> kGradientCool = [0xFF667EEA, 0xFF764BA2];
const List<int> kGradientWarm = [0xFFFF8C42, 0xFFFFC800];

/// Shadow / 3D elevation
const int kShadowColor = 0x14000000;          // 8% black
const int kShadowColorLight = 0x0D000000;
const int kShadowColorMedium = 0x26000000;
const int kShadowColorGreen = 0x2E58CC02;     // 18% primary - for green glow

/// Dark mode colors
const int kColorDarkBackground = 0xFF1A1B2A;
const int kColorDarkSurface = 0xFF252736;
const int kColorDarkSurfaceAlt = 0xFF2F3142;
const int kColorDarkTextPrimary = 0xFFF5F5F7;
const int kColorDarkTextSecondary = 0xFFA0A0AC;
const int kColorDarkTextHint = 0xFF6B6B7B;

/// ============================================================================
/// Mood color scale (5 levels for mood tracking / DayWall)
/// ============================================================================
const List<int> kMoodColors = [
  0xFFFF4B4B, // 1 - 很差 (红)
  0xFFFF8C42, // 2 - 不好 (橙)
  0xFFFFC800, // 3 - 一般 (黄)
  0xFF58CC02, // 4 - 好 (绿)
  0xFFCE82FF, // 5 - 非常好 (紫)
];
const List<String> kMoodEmojis = ['😢', '😟', '😐', '😊', '🔥'];

/// ============================================================================
/// Neural Recovery Descriptions - 神经恢复描述（科学叙事）
/// ============================================================================
const Map<int, String> kNeuralRecoveryDescriptions = {
  1: '多巴胺受体开始适应非人工刺激的节奏',
  2: '大脑的注意力资源正在重新分配',
  3: '神经递质水平正在逐步稳定',
  7: '习惯系统开始重校准',
  14: '前额叶功能持续改善中',
  21: '自我效能感建立窗口期',
  30: '神经递质水平初步恢复基线',
  60: '多巴胺受体密度开始增加',
  90: '神经系统的恢复进程持续进行（多巴胺受体恢复需要约90天）',
};

/// ============================================================================
/// Milestones - 里程碑
/// ============================================================================
const List<int> kMilestones = [7, 14, 30, 60, 90, 180, 365];
const Map<int, String> kMilestoneNames = {
  7: '初绽',
  14: '嫩芽',
  30: '破土',
  60: '向阳',
  90: '盛放',
  180: '硕果',
  365: '传奇',
};
const Map<int, String> kMilestoneEmojis = {
  7: '🌱',
  14: '🌿',
  30: '🌸',
  60: '🌻',
  90: '🏵️',
  180: '🌺',
  365: '🌳',
};

/// ============================================================================
/// XP/Level system
/// ============================================================================
const List<int> kLevelThresholds = [
  0, 100, 300, 600, 1000, 1500, 2100, 2800, 3600, 4500, 5500,
];
const List<String> kLevelTitles = [
  '新手', '萌芽', '成长', '觉醒', '坚定',
  '战士', '勇者', '大师', '传奇', '神话', '不朽',
];

/// XP rewards
const int kXPDailyCheckIn = 20;
const int kXPUrgeResisted = 50;
const int kXPTechniqueComplete = 30;
const int kXPStreak7Day = 200;
const int kXPStreak30Day = 1000;
const int kXPJournalEntry = 15;
const int kXPTriggerLog = 10;

/// ============================================================================
/// Default settings
/// ============================================================================
const int kDefaultAbstinenceGoal = 30;
const int kDefaultUrgeLevel = 5;
const int kMinUrgeLevel = 1;
const int kMaxUrgeLevel = 10;

/// Risk period thresholds
const int kHighRiskSoloHours = 2;
const int kHighRiskHourStart = 1;
const int kHighRiskHourEnd = 5;
const int kTriggerComboThreshold = 3;

/// Trigger emotion types
const List<String> kTriggerEmotions = [
  '无聊',
  '压力大',
  '孤独',
  '焦虑',
  '看见诱因',
  '睡前',
  '其他',
];

/// Storage keys
const String kStorageDbName = 'qingliu.db';
const String kStorageAbstinenceStart = 'abstinence_start';
const String kStorageGoalDays = 'goal_days';
const String kStorageNotificationsEnabled = 'notifications_enabled';
const String kStorageMilestoneAlertsEnabled = 'milestone_alerts_enabled';
const String kStorageDarkModeEnabled = 'dark_mode_enabled';
const String kStorageLocale = 'locale';
const String kStorageXP = 'user_xp';
const String kStorageAchievements = 'achievements';
const String kStorageMoodEntries = 'mood_entries';

/// ============================================================================
/// Animation durations (Lingo-style: short, purposeful)
/// ============================================================================
const int kAnimDurationMs = 230;          // Lingo --motion-base
const int kAnimDurationFastMs = 150;      // Lingo --motion-fast
const int kAnimDurationSlowMs = 400;
const int kAnimDurationCelebrationMs = 1500;

/// ============================================================================
/// UI dimensions - 统一圆角系统 (Lingo: rounded, tactile)
/// ============================================================================
const double kBorderRadius = 16.0;
const double kBorderRadiusSmall = 10.0;
const double kBorderRadiusLarge = 24.0;
const double kBorderRadiusXLarge = 32.0;
const double kBorderRadiusPill = 9999.0;
const double kPaddingSmall = 8.0;
const double kPaddingMedium = 16.0;
const double kPaddingLarge = 24.0;
const double kPaddingXLarge = 32.0;
const double kSafeAreaBottom = 34.0;

/// 3D border thickness for tactile effect
const double kBorderWidth3D = 2.0;
const double kBorderWidth3DThick = 3.0;

/// ============================================================================
/// Touch target sizes - 手指友好尺寸
/// ============================================================================
const double kMinButtonHeight = 56.0;
const double kMinTouchTarget = 48.0;

/// ============================================================================
/// DayWall - mood timeline grid
/// ============================================================================
const int kDayWallDays = 30;
const int kDayWallColumns = 7;