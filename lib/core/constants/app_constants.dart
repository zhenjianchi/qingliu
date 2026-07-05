/// App-wide constants for 清流 (Qingliu)
/// V3.0 - Designer-provided Apple aesthetic
/// (replaces Lingo/Gamified V2.0 direction)
library;

/// App metadata
const String kAppName = '清流';
const String kAppNameEn = 'Qingliu';
const String kAppVersion = '3.0.0';
const int kBuildNumber = 3;

/// ============================================================================
/// Apple-style Color Palette
/// Reference: doc/design/20260705/HTML/*.html
/// 核心理念：克制、温暖、成熟、不评判
/// ============================================================================

/// Background colors - warm cream
const int kColorBackground = 0xFFFBF8F1;       // 主背景 - 暖奶白
const int kColorSurface = 0xFFF3ECE0;          // 卡片背景
const int kColorSurfaceWarm = 0xFFF8F2E6;      // 暖卡片
const int kColorSurfaceAlt = 0xFFEFE7D8;       // 交替背景

/// Text colors - warm dark
const int kColorTextPrimary = 0xFF2C2620;      // 主文字
const int kColorTextSecondary = 0xFF5A544A;    // 次要文字
const int kColorTextHint = 0xFF8B7E6E;         // 提示文字
const int kColorTextMeta = 0xFFA99C8A;         // 元信息
const int kColorTextOnPrimary = 0xFFFFFFFF;    // 主色上文字

/// Border colors
const int kColorBorder = 0xFFE3D9C4;
const int kColorBorderSoft = 0xFFEBE3D0;

/// Accent - Apple Blue
const int kColorPrimary = 0xFF0071E3;          // Apple 蓝
const int kColorPrimaryHover = 0xFF0077ED;
const int kColorPrimaryActive = 0xFF0066CC;
const int kColorPrimaryDark = 0xFF0066CC;
const int kColorPrimaryLight = 0xFFE9FAD9;

/// Secondary - alias for Apple Blue (V2 compat)
const int kColorSecondary = 0xFF0071E3;
const int kColorSecondaryDark = 0xFF0066CC;
const int kColorSecondaryLight = 0xFFE9FAD9;

/// Accent - alias for Apple Blue (V2 compat)
const int kColorAccent = 0xFF0071E3;
const int kColorAccentDark = 0xFF0066CC;
const int kColorAccentLight = 0xFFE9FAD9;

/// Semantic
const int kColorSuccess = 0xFF16A34A;
const int kColorWarning = 0xFFEAB308;
const int kColorDanger = 0xFFDC2626;
const int kColorError = 0xFFDC2626;

/// Dark mode colors (warm dark)
const int kColorDarkBackground = 0xFF1C1916;
const int kColorDarkSurface = 0xFF292524;
const int kColorDarkSurfaceAlt = 0xFF34302D;
const int kColorDarkTextPrimary = 0xFFF5F5F4;
const int kColorDarkTextSecondary = 0xFFA8A29E;
const int kColorDarkTextHint = 0xFF78716C;
const int kColorDarkBorder = 0xFF3A3530;

/// ============================================================================
/// Mood color scale (kept for DayWall)
/// ============================================================================
const List<int> kMoodColors = [
  0xFFDC2626, // 1 - 红
  0xFFEAB308, // 2 - 黄
  0xFF8B7E6E, // 3 - 灰
  0xFF16A34A, // 4 - 绿
  0xFF0071E3, // 5 - 蓝
];
const List<String> kMoodEmojis = ['😢', '😟', '😐', '😊', '✨'];

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
  90: '神经系统的恢复进程持续进行',
};

/// ============================================================================
/// Milestones
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
/// XP/Level system (kept for compatibility)
/// ============================================================================
const List<int> kLevelThresholds = [
  0, 100, 300, 600, 1000, 1500, 2100, 2800, 3600, 4500, 5500,
];
const List<String> kLevelTitles = [
  '新手', '萌芽', '成长', '觉醒', '坚定',
  '战士', '勇者', '大师', '传奇', '神话', '不朽',
];

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

const int kHighRiskSoloHours = 2;
const int kHighRiskHourStart = 1;
const int kHighRiskHourEnd = 5;
const int kTriggerComboThreshold = 3;

const List<String> kTriggerEmotions = [
  '无聊', '压力大', '孤独', '焦虑', '看见诱因', '睡前', '其他',
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
const String kStorageUserName = 'user_name';

/// ============================================================================
/// Animation (Apple-style: 220ms standard)
/// ============================================================================
const int kAnimDurationMs = 220;
const int kAnimDurationFastMs = 150;
const int kAnimDurationSlowMs = 400;

/// ============================================================================
/// UI dimensions - Apple-style radii
/// ============================================================================
const double kBorderRadius = 14.0;           // --radius-md
const double kBorderRadiusSmall = 8.0;       // --radius-sm
const double kBorderRadiusLarge = 18.0;      // --radius-lg
const double kBorderRadiusXLarge = 28.0;
const double kBorderRadiusPill = 980.0;      // --radius-pill
const double kPaddingSmall = 8.0;
const double kPaddingMedium = 16.0;
const double kPaddingLarge = 20.0;
const double kPaddingXLarge = 28.0;
const double kSafeAreaBottom = 34.0;

/// Touch targets
const double kMinButtonHeight = 48.0;
const double kMinTouchTarget = 44.0;

/// DayWall
const int kDayWallDays = 30;
const int kDayWallColumns = 7;