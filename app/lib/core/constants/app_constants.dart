/// App-wide constants for 清流 (Qingliu)
library;

/// App metadata
const String kAppName = '清流';
const String kAppNameEn = 'Qingliu';
const String kAppVersion = '1.0.0';
const int kBuildNumber = 1;

/// Color palette
const int kColorPrimary = 0xFF1F3A5F;       // Deep navy - trust/professional
const int kColorSecondary = 0xFF4472C4;     // Light blue - vitality/health
const int kColorAccent = 0xFF4CAF50;        // Mint green - positive/forward
const int kColorBackground = 0xFFF5F7FA;    // Soft gray-white
const int kColorSurface = 0xFFFFFFFF;       // White
const int kColorTextPrimary = 0xFF333333;   // Dark gray
const int kColorTextSecondary = 0xFF666666; // Medium gray
const int kColorTextHint = 0xFF999999;     // Light gray
const int kColorError = 0xFFE53935;         // Red
const int kColorWarning = 0xFFFFA726;       // Orange

/// Abstinence milestones (in days)
const List<int> kMilestones = [7, 14, 30, 60, 90, 180, 365];
const Map<int, String> kMilestoneNames = {
  7: '青铜',
  14: '白银',
  30: '黄金',
  60: '铂金',
  90: '钻石',
  180: '大师',
  365: '传奇',
};
const Map<int, String> kMilestoneEmojis = {
  7: '🥉',
  14: '🥈',
  30: '🥇',
  60: '💎',
  90: '🏆',
  180: '🌟',
  365: '👑',
};

/// Default settings
const int kDefaultAbstinenceGoal = 30;  // days
const int kDefaultUrgeLevel = 5;
const int kMinUrgeLevel = 1;
const int kMaxUrgeLevel = 10;

/// Risk period thresholds
const int kHighRiskSoloHours = 2;       // hours of continuous solitude
const int kHighRiskHourStart = 1;        // 1:00 AM
const int kHighRiskHourEnd = 5;          // 5:00 AM
const int kTriggerComboThreshold = 3;    // boredom+loneliness combo per week

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

/// Animation durations
const int kAnimDurationMs = 300;
const int kAnimDurationFastMs = 150;
const int kAnimDurationSlowMs = 600;

/// UI dimensions
const double kBorderRadius = 12.0;
const double kBorderRadiusSmall = 8.0;
const double kBorderRadiusLarge = 16.0;
const double kPaddingSmall = 8.0;
const double kPaddingMedium = 16.0;
const double kPaddingLarge = 24.0;
const double kSafeAreaBottom = 34.0; // iPhone notch area