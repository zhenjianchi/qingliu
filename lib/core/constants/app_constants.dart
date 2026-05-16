/// App-wide constants for 清流 (Qingliu)
library;

/// App metadata
const String kAppName = '清流';
const String kAppNameEn = 'Qingliu';
const String kAppVersion = '1.0.0';
const int kBuildNumber = 1;

/// ============================================================================
/// Modern Health Tech Color Palette - 现代健康科技色系
/// 核心理念：科技感、清爽、专业、年轻化
/// ============================================================================

/// Primary colors - Ocean Blue (科技感、信任、冷静)
const int kColorPrimary = 0xFF0077B6;       // 海洋蓝
const int kColorPrimaryDark = 0xFF005F8A;   // 深海洋蓝
const int kColorPrimaryLight = 0xFFE6F3FF; // 浅蓝背景

/// Secondary colors - Soft Blue Gray
const int kColorSecondary = 0xFF5C6B73;     // 蓝灰色
const int kColorSecondaryDark = 0xFF4A565E;
const int kColorSecondaryLight = 0xFF8A9399;

/// Accent colors - Fresh Teal (活力、健康、成长)
const int kColorAccent = 0xFF00D4AA;        // 清新绿
const int kColorAccentDark = 0xFF00B894;
const int kColorAccentLight = 0xFFB8F4E0;

/// Background colors - Cool modern
const int kColorBackground = 0xFFF8FAFB;    // 冷白背景
const int kColorSurface = 0xFFFFFFFF;       // 纯白卡片
const int kColorSurfaceAlt = 0xFFF0F4F8;    // 交替卡片

/// Text colors - Clear contrast
const int kColorTextPrimary = 0xFF1A2634;   // 深色文字
const int kColorTextSecondary = 0xFF5C6B73; // 次要文字
const int kColorTextHint = 0xFF9AA5B1;     // 提示文字
const int kColorTextOnPrimary = 0xFFFFFFFF; // 主色上文字

/// Semantic colors
const int kColorError = 0xFFE53935;         // 红色
const int kColorWarning = 0xFFFF9800;      // 橙色
const int kColorSuccess = 0xFF00D4AA;      // 绿色
const int kColorInfo = 0xFF0077B6;         // 蓝色

/// Gradient definitions
const List<int> kGradientPrimary = [0xFF0077B6, 0xFF00B4D8]; // 蓝色渐变
const List<int> kGradientAccent = [0xFF00D4AA, 0xFF00B894];  // 绿色渐变
const List<int> kGradientCool = [0xFF667EEA, 0xFF764BA2];   // 紫色渐变

/// Shadow colors
const int kShadowColor = 0x1A000000;
const int kShadowColorLight = 0x0D000000;
const int kShadowColorMedium = 0x26000000;

/// Dark mode colors
const int kColorDarkBackground = 0xFF0F1419;
const int kColorDarkSurface = 0xFF1A2634;
const int kColorDarkSurfaceAlt = 0xFF242D3B;
const int kColorDarkTextPrimary = 0xFFE7E9EA;
const int kColorDarkTextSecondary = 0xFF8B98A5;
const int kColorDarkTextHint = 0xFF6E7681;

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

/// ============================================================================
/// Animation durations
/// ============================================================================
const int kAnimDurationMs = 300;
const int kAnimDurationFastMs = 150;
const int kAnimDurationSlowMs = 600;

/// ============================================================================
/// UI dimensions - 统一圆角系统
/// ============================================================================
const double kBorderRadius = 16.0;
const double kBorderRadiusSmall = 12.0;
const double kBorderRadiusLarge = 24.0;
const double kBorderRadiusXLarge = 32.0;
const double kPaddingSmall = 8.0;
const double kPaddingMedium = 16.0;
const double kPaddingLarge = 24.0;
const double kPaddingXLarge = 32.0;
const double kSafeAreaBottom = 34.0;

/// ============================================================================
/// Touch target sizes - 手指友好尺寸
/// ============================================================================
const double kMinButtonHeight = 56.0;    // 最小按钮高度
const double kMinTouchTarget = 48.0;     // 最小触控区域