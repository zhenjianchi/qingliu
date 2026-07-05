# 清流 V2.0 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Implement the V2.0 redesign of 清流 app, transforming it from a clinical habit tracker into a gamified, emotionally engaging companion for young戒色 users, using Open Design's Lingo design system.

**Architecture:** 
- Replace the current medical-blue theme with Lingo's vibrant green/purple palette + Nunito rounded font
- Add new design primitives: TactileCard, Pill, StepCounter, LevelBadge, DayWall
- Rebuild Home, Urge Panel, and Stats screens with the new visual language
- Introduce XP/Level system + Achievement system with tactile 3D badges
- Build Onboarding flow with value-props carousel + demo data
- All new code TDD where practical, with frequent atomic commits

**Tech Stack:** Flutter 3.x, Dart, flutter_bloc, flutter_localizations, shared_preferences, google_fonts (for Nunito), confetti (for celebrations)

**Reference:** Design spec at `docs/plans/2026-07-05-v2-design.md`

---

## Phase 1: Design System Foundation (P0)

### Task 1.1: Add Nunito font via google_fonts

**Files:**
- Modify: `pubspec.yaml:30-50`

**Step 1: Add google_fonts dependency**

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1
```

**Step 2: Run pub get**

Run: `cd /Users/mac/Desktop/repo/qingliu && ~/flutter/flutter/bin/flutter pub get`
Expected: Successfully resolved and got dependencies

**Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat(deps): add google_fonts for Nunito rounded font"
```

---

### Task 1.2: Update color constants to Lingo palette

**Files:**
- Modify: `lib/core/constants/app_constants.dart:1-100`

**Step 1: Replace color constants**

Replace the color palette with Lingo tokens:

```dart
// Lingo design system colors
const int kColorPrimary = 0xFF58CC02;        // Duolingo green
const int kColorPrimaryDark = 0xFF46A601;
const int kColorSecondary = 0xFFCE82FF;       // Lavender purple
const int kColorSecondaryDark = 0xFFA65AE8;
const int kColorWarning = 0xFFFFC800;
const int kColorDanger = 0xFFFF4B4B;

// Surface
const int kColorBackground = 0xFFFAFAFA;       // Light bg
const int kColorSurface = 0xFFFFFFFF;
const int kColorSurfaceAlt = 0xFFF7F7F7;

// Dark mode
const int kColorBackgroundDark = 0xFF1A1B2A;
const int kColorSurfaceDark = 0xFF252736;

// Text
const int kColorTextPrimary = 0xFF3C3C3C;
const int kColorTextSecondary = 0xFF6B6B6B;
const int kColorTextHint = 0xFF9CA3AF;
const int kColorTextPrimaryDark = 0xFFF5F5F7;
const int kColorTextSecondaryDark = 0xFFA0A0AC;

// 3D elevation
const int kShadowColor = 0x14000000;          // 8% black
const int kShadowColorGreen = 0x2E58CC02;     // 18% primary

// Spacing
const double kPaddingSmall = 8.0;
const double kPaddingMedium = 16.0;
const double kPaddingLarge = 24.0;
const double kPaddingXLarge = 32.0;

// Radii
const double kBorderRadius = 16.0;             // cards
const double kBorderRadiusLarge = 24.0;        // big cards
const double kBorderRadiusXLarge = 32.0;       // hero
const double kBorderRadiusPill = 9999.0;
```

**Step 2: Verify build**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -10`
Expected: Build succeeds with no errors

**Step 3: Commit**

```bash
git add lib/core/constants/app_constants.dart
git commit -m "feat(theme): migrate color palette to Lingo design system"
```

---

### Task 1.3: Update theme with Nunito + new colors

**Files:**
- Modify: `lib/core/theme/app_theme.dart:1-50`

**Step 1: Replace AppTheme with Lingo-based theme**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get light {
    final textTheme = GoogleFonts.nunitoTextTheme().apply(
      bodyColor: const Color(kColorTextPrimary),
      displayColor: const Color(kColorTextPrimary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(kColorBackground),
      colorScheme: const ColorScheme.light(
        primary: Color(kColorPrimary),
        secondary: Color(kColorSecondary),
        surface: Color(kColorSurface),
        error: Color(kColorDanger),
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(kColorBackground),
        foregroundColor: const Color(kColorTextPrimary),
        elevation: 0,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(kColorTextPrimary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(kColorPrimary),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: kPaddingLarge,
            vertical: kPaddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final textTheme = GoogleFonts.nunitoTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    ).apply(
      bodyColor: const Color(kColorTextPrimaryDark),
      displayColor: const Color(kColorTextPrimaryDark),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(kColorBackgroundDark),
      colorScheme: const ColorScheme.dark(
        primary: Color(kColorPrimary),
        secondary: Color(kColorSecondary),
        surface: Color(kColorSurfaceDark),
        error: Color(kColorDanger),
      ),
      textTheme: textTheme,
    );
  }
}
```

**Step 2: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -10`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add lib/core/theme/app_theme.dart
git commit -m "feat(theme): integrate Nunito font and Lingo theme tokens"
```

---

### Task 1.4: Create TactileCard widget (3D thick-border card)

**Files:**
- Create: `lib/presentation/widgets/tactile_card.dart`

**Step 1: Create the widget**

```dart
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// A card with tactile 3D borders (Duolingo-style)
/// Uses a bottom shadow strip to create depth
class TactileCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double borderWidth;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const TactileCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = kBorderRadiusLarge,
    this.borderWidth = 2,
    this.onTap,
    this.padding = const EdgeInsets.all(kPaddingLarge),
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final border = borderColor ?? const Color(kColorPrimary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: border, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: border.withAlpha(77),
                blurRadius: 0,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
```

**Step 2: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -5`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add lib/presentation/widgets/tactile_card.dart
git commit -m "feat(ui): add TactileCard widget with 3D border effect"
```

---

### Task 1.5: Create Pill, StepCounter, LevelBadge widgets

**Files:**
- Create: `lib/presentation/widgets/atoms.dart`

**Step 1: Create atoms file with multiple small widgets**

```dart
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Pill-shaped chip / tag
class Pill extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;

  const Pill({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? const Color(kColorPrimary);
    final fg = textColor ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(kBorderRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: fg, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Big number with label (replaces progress ring)
class StepCounter extends StatelessWidget {
  final String number;
  final String label;
  final Color? color;
  final double numberSize;

  const StepCounter({
    super.key,
    required this.number,
    required this.label,
    this.color,
    this.numberSize = 96,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(kColorPrimary);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: numberSize,
            fontWeight: FontWeight.w900,
            color: c,
            height: 1.0,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: c.withAlpha(200),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

/// Level badge with 3D effect
class LevelBadge extends StatelessWidget {
  final int level;
  final String title;
  final double size;

  const LevelBadge({
    super.key,
    required this.level,
    this.title = 'Lv',
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(kColorPrimary), Color(0xFF7BE325)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(kColorPrimary).withAlpha(102),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              '$level',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Step 2: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -5`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add lib/presentation/widgets/atoms.dart
git commit -m "feat(ui): add Pill, StepCounter, LevelBadge atomic components"
```

---

### Task 1.6: Create DayWall widget (mood + emoji timeline)

**Files:**
- Create: `lib/presentation/widgets/day_wall.dart`

**Step 1: Create the DayWall widget**

```dart
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class DayEntry {
  final DateTime date;
  final int moodLevel; // 1-5
  final bool hasRecord;

  const DayEntry({
    required this.date,
    required this.moodLevel,
    this.hasRecord = false,
  });
}

/// DayWall: 30-day mood timeline as emoji cards
class DayWall extends StatelessWidget {
  final List<DayEntry> entries;
  final ValueChanged<DayEntry>? onTap;

  const DayWall({
    super.key,
    required this.entries,
    this.onTap,
  });

  static const _moodEmojis = ['😢', '😟', '😐', '😊', '🔥'];
  static const _moodColors = [
    Color(0xFFFF4B4B),
    Color(0xFFFF8C42),
    Color(0xFFFFC800),
    Color(0xFF58CC02),
    Color(0xFFCE82FF),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final color = _moodColors[entry.moodLevel.clamp(1, 5) - 1];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap == null ? null : () => onTap!(entry),
            child: Container(
              decoration: BoxDecoration(
                color: color.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
                border: entry.hasRecord
                    ? Border.all(color: color, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  _moodEmojis[entry.moodLevel.clamp(1, 5) - 1],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```

**Step 2: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -5`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add lib/presentation/widgets/day_wall.dart
git commit -m "feat(ui): add DayWall mood timeline widget"
```

---

## Phase 2: Home Screen Rebuild (P0)

### Task 2.1: Add domain entities for new features

**Files:**
- Create: `lib/domain/entities/user_level.dart`
- Create: `lib/domain/entities/achievement.dart`
- Create: `lib/domain/entities/mood_entry.dart`

**Step 1: Create UserLevel entity**

```dart
class UserLevel {
  final int level;
  final int currentXP;
  final int nextLevelXP;
  final String title;

  const UserLevel({
    required this.level,
    required this.currentXP,
    required this.nextLevelXP,
    required this.title,
  });

  double get progress => currentXP / nextLevelXP;

  static UserLevel fromXP(int xp) {
    // Level thresholds: 0, 100, 300, 600, 1000, 1500, 2100...
    final thresholds = [0, 100, 300, 600, 1000, 1500, 2100, 2800, 3600, 4500, 5500];
    final titles = [
      '新手', '萌芽', '成长', '觉醒', '坚定',
      '战士', '勇者', '大师', '传奇', '神话', '不朽'
    ];

    int level = 1;
    for (int i = 1; i < thresholds.length; i++) {
      if (xp >= thresholds[i]) level = i + 1;
    }
    level = level.clamp(1, titles.length);

    final nextThreshold = level < thresholds.length
        ? thresholds[level]
        : thresholds.last + (level - thresholds.length + 1) * 1000;

    return UserLevel(
      level: level,
      currentXP: xp - thresholds[level - 1],
      nextLevelXP: nextThreshold - thresholds[level - 1],
      title: titles[level - 1],
    );
  }
}
```

**Step 2: Create Achievement entity**

```dart
import 'package:flutter/material.dart';

enum AchievementCategory {
  persistence,  // 坚持
  response,     // 应对
  reflection,   // 反思
  learning,     // 学习
  special,      // 特殊
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementCategory category;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    this.unlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({bool? unlocked, DateTime? unlockedAt}) {
    return Achievement(
      id: id,
      name: name,
      description: description,
      category: category,
      icon: icon,
      color: color,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
```

**Step 3: Create MoodEntry entity**

```dart
class MoodEntry {
  final DateTime date;
  final int moodLevel; // 1-5
  final String? note;
  final List<String> tags;

  const MoodEntry({
    required this.date,
    required this.moodLevel,
    this.note,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'moodLevel': moodLevel,
    'note': note,
    'tags': tags,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    date: DateTime.parse(json['date'] as String),
    moodLevel: json['moodLevel'] as int,
    note: json['note'] as String?,
    tags: (json['tags'] as List?)?.cast<String>() ?? const [],
  );
}
```

**Step 4: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -5`
Expected: Build succeeds

**Step 5: Commit**

```bash
git add lib/domain/entities/user_level.dart \
        lib/domain/entities/achievement.dart \
        lib/domain/entities/mood_entry.dart
git commit -m "feat(domain): add UserLevel, Achievement, MoodEntry entities"
```

---

### Task 2.2: Add XP and Achievement logic

**Files:**
- Create: `lib/domain/services/xp_service.dart`
- Create: `lib/domain/services/achievement_service.dart`

**Step 1: Create XPService**

```dart
class XPService {
  // XP rewards for actions
  static const int xpDailyCheckIn = 20;
  static const int xpUrgeResisted = 50;
  static const int xpTechniqueComplete = 30;
  static const int xpStreak7Day = 200;
  static const int xpStreak30Day = 1000;
  static const int xpJournalEntry = 15;
  static const int xpTriggerLog = 10;

  /// Calculate total XP earned today
  static int calculateDailyXP({
    required bool didCheckIn,
    required int urgesResisted,
    required int techniquesCompleted,
    required bool wroteJournal,
  }) {
    int xp = 0;
    if (didCheckIn) xp += xpDailyCheckIn;
    xp += urgesResisted * xpUrgeResisted;
    xp += techniquesCompleted * xpTechniqueComplete;
    if (wroteJournal) xp += xpJournalEntry;
    return xp;
  }
}
```

**Step 2: Create AchievementService with predefined list**

```dart
import 'package:flutter/material.dart';
import '../entities/achievement.dart';

class AchievementService {
  static List<Achievement> getAllAchievements() {
    return [
      // Persistence
      Achievement(
        id: 'day_1',
        name: '启程',
        description: '完成第1天',
        category: AchievementCategory.persistence,
        icon: Icons.flag,
        color: const Color(0xFF58CC02),
      ),
      Achievement(
        id: 'day_7',
        name: '一周坚持',
        description: '连续7天',
        category: AchievementCategory.persistence,
        icon: Icons.local_fire_department,
        color: const Color(0xFFFF8C42),
      ),
      Achievement(
        id: 'day_30',
        name: '月度勇士',
        description: '连续30天',
        category: AchievementCategory.persistence,
        icon: Icons.workspace_premium,
        color: const Color(0xFFCE82FF),
      ),
      Achievement(
        id: 'day_90',
        name: '季度大师',
        description: '连续90天',
        category: AchievementCategory.persistence,
        icon: Icons.emoji_events,
        color: const Color(0xFFFFC800),
      ),

      // Response
      Achievement(
        id: 'first_response',
        name: '首次应对',
        description: '成功应对第一次渴望',
        category: AchievementCategory.response,
        icon: Icons.shield,
        color: const Color(0xFF58CC02),
      ),
      Achievement(
        id: 'response_100',
        name: '百战老兵',
        description: '成功应对100次',
        category: AchievementCategory.response,
        icon: Icons.military_tech,
        color: const Color(0xFF5B6CFF),
      ),

      // Reflection
      Achievement(
        id: 'first_journal',
        name: '第一篇日记',
        description: '写下第一篇反思',
        category: AchievementCategory.reflection,
        icon: Icons.edit_note,
        color: const Color(0xFFCE82FF),
      ),
      Achievement(
        id: 'journal_streak_30',
        name: '反思达人',
        description: '连续30天记录',
        category: AchievementCategory.reflection,
        icon: Icons.menu_book,
        color: const Color(0xFFFFC800),
      ),

      // Learning
      Achievement(
        id: 'all_techniques',
        name: '技巧通',
        description: '学会所有应对技巧',
        category: AchievementCategory.learning,
        icon: Icons.school,
        color: const Color(0xFF58CC02),
      ),

      // Special
      Achievement(
        id: 'early_bird_30',
        name: '早起鸟',
        description: '连续30天早睡',
        category: AchievementCategory.special,
        icon: Icons.wb_sunny,
        color: const Color(0xFFFFC800),
      ),
    ];
  }
}
```

**Step 3: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -5`
Expected: Build succeeds

**Step 4: Commit**

```bash
git add lib/domain/services/xp_service.dart \
        lib/domain/services/achievement_service.dart
git commit -m "feat(domain): add XP and Achievement services with predefined achievements"
```

---

### Task 2.3: Rewrite HomePage with new design

**Files:**
- Modify: `lib/presentation/pages/home_page.dart` (full rewrite)

**Step 1: Rewrite HomePage**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/user_level.dart';
import '../blocs/abstinence_bloc.dart';
import '../widgets/atoms.dart';
import '../widgets/day_wall.dart';
import '../widgets/tactile_card.dart';
import 'urge_panel_page.dart';
import 'trigger_log_page.dart';
import 'relapse_support_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AbstinenceBloc, AbstinenceState>(
        listener: (context, state) {
          if (state is AbstinenceJustRelapsed) {
            _showRelapseDialog(context, state);
          }
        },
        builder: (context, state) {
          if (state is AbstinenceLoading || state is AbstinenceInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(kColorPrimary)),
            );
          }
          if (state is AbstinenceNoRecord) return _buildNoRecordView(context);
          if (state is AbstinenceActive) return _buildActiveView(context, state);
          if (state is AbstinenceError) {
            return Center(child: Text('错误: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: _UrgeFab(),
    );
  }

  Widget _buildNoRecordView(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              '你不是一个人在战斗',
              style: GoogleFonts.nunito(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: const Color(kColorTextPrimary),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '科学戒色，从这里开始',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: const Color(kColorTextSecondary),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TactileCard(
              onTap: () {
                context.read<AbstinenceBloc>().add(AbstinenceStartRequested(30));
              },
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 20,
              ),
              child: const Text(
                '开始 30 天挑战',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveView(BuildContext context, AbstinenceActive state) {
    final days = state.daysSober;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top status bar
            Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: Color(kColorWarning), size: 24),
                const SizedBox(width: 8),
                Text(
                  '$days 天 · 大脑觉醒中',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(kColorTextPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Hero number
            Center(
              child: StepCounter(
                number: '$days',
                label: 'DAYS STRONG',
              ),
            ),
            const SizedBox(height: 24),

            // Brain recovery narrative
            TactileCard(
              borderColor: const Color(kColorSecondary),
              child: Row(
                children: [
                  const Text('🧠', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '你的前额叶正在重建连接',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(kColorTextPrimary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getBrainRecoveryMessage(days),
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: const Color(kColorTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daily ritual
            Text(
              '今日仪式',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(kColorTextPrimary),
              ),
            ),
            const SizedBox(height: 12),
            _buildRitualCards(context),
            const SizedBox(height: 24),

            // Day wall placeholder
            Text(
              '心情时间墙',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(kColorTextPrimary),
              ),
            ),
            const SizedBox(height: 12),
            DayWall(
              entries: List.generate(
                30,
                (i) => DayEntry(
                  date: DateTime.now().subtract(Duration(days: 29 - i)),
                  moodLevel: ((i + days) % 5) + 1,
                  hasRecord: i > 5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent achievements preview
            Text(
              '最近成就',
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(kColorTextPrimary),
              ),
            ),
            const SizedBox(height: 12),
            _buildAchievementRow(context, days),
            const SizedBox(height: 24),

            // Level
            _buildLevelSection(context),
            const SizedBox(height: 80), // space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildRitualCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TactileCard(
            borderColor: const Color(kColorWarning),
            onTap: () {},
            padding: const EdgeInsets.all(kPaddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('☀️', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 8),
                Text(
                  '早晨承诺',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '<10秒完成',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: const Color(kColorTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TactileCard(
            borderColor: const Color(kColorSecondary),
            onTap: () {},
            padding: const EdgeInsets.all(kPaddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🌙', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 8),
                Text(
                  '傍晚回顾',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '<2分钟',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: const Color(kColorTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementRow(BuildContext context, int days) {
    return Row(
      children: [
        _buildBadgeItem('🥉', '7天坚持', days >= 7),
        const SizedBox(width: 12),
        _buildBadgeItem('⭐', '首次应对', true),
        const SizedBox(width: 12),
        _buildBadgeItem('🎯', '30天目标', days >= 30),
      ],
    );
  }

  Widget _buildBadgeItem(String emoji, String name, bool unlocked) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unlocked
              ? const Color(kColorPrimary).withAlpha(26)
              : const Color(kColorSurfaceAlt),
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: unlocked
              ? Border.all(color: const Color(kColorPrimary), width: 2)
              : null,
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 28, color: unlocked ? null : Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: unlocked
                    ? const Color(kColorTextPrimary)
                    : const Color(kColorTextHint),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSection(BuildContext context) {
    final userLevel = UserLevel.fromXP(days * 50);
    return TactileCard(
      borderColor: const Color(kColorPrimary),
      child: Row(
        children: [
          LevelBadge(level: userLevel.level),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lv ${userLevel.level} · ${userLevel.title}',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: userLevel.progress,
                    minHeight: 8,
                    backgroundColor: const Color(kColorSurfaceAlt),
                    valueColor: const AlwaysStoppedAnimation(
                      Color(kColorPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'XP: ${userLevel.currentXP}/${userLevel.nextLevelXP}',
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    color: const Color(kColorTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBrainRecoveryMessage(int days) {
    if (days < 7) return '戒断初期 - 多巴胺受体开始恢复敏感度';
    if (days < 14) return '前额叶开始重获掌控力';
    if (days < 30) return '突触连接重塑中 - 你的意志力在增强';
    if (days < 90) return '深层神经通路已经重新校准';
    return '你的大脑已建立新的奖赏回路';
  }

  void _showRelapseDialog(BuildContext context, AbstinenceJustRelapsed state) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => RelapseSupportPage(record: state.record),
    ));
  }
}

class _UrgeFab extends StatefulWidget {
  @override
  State<_UrgeFab> createState() => _UrgeFabState();
}

class _UrgeFabState extends State<_UrgeFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UrgePanelPage()),
        ),
        backgroundColor: const Color(kColorPrimary),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.bolt, size: 28),
        label: Text(
          '渴望',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -10`
Expected: Build succeeds

**Step 3: Run app to visually verify**

Run: `~/flutter/flutter/bin/flutter run -d macos`
Expected: App launches with new green Lingo theme, hero number, DayWall visible

**Step 4: Commit**

```bash
git add lib/presentation/pages/home_page.dart
git commit -m "feat(home): rebuild with Lingo design and new features"
```

---

## Phase 3: Urge Panel Rebuild (P0)

### Task 3.1: Rebuild UrgePanelPage with semantic 3-choice

**Files:**
- Modify: `lib/presentation/pages/urge_panel_page.dart`

**Step 1: Replace urge intensity slider with semantic 3-choice**

Replace the urge level slider section in `_buildUrgeLevelSection` with:

```dart
Widget _buildUrgeLevelSection(BuildContext context) {
  return Column(
    children: [
      Text(
        '此刻你的渴望是什么感觉？',
        style: GoogleFonts.nunito(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: const Color(kColorTextPrimary),
        ),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: _buildIntensityCard(
              context,
              emoji: '😌',
              label: '有点想',
              range: '1-3',
              color: const Color(0xFFFFC800),
              onTap: () => _onUrgeLevelChanged(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildIntensityCard(
              context,
              emoji: '😰',
              label: '很强烈',
              range: '4-7',
              color: const Color(0xFFFF8C42),
              onTap: () => _onUrgeLevelChanged(5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildIntensityCard(
              context,
              emoji: '🔥',
              label: '压不住',
              range: '8-10',
              color: const Color(0xFFFF4B4B),
              onTap: () => _onUrgeLevelChanged(8),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildIntensityCard(
  BuildContext context, {
  required String emoji,
  required String label,
  required String range,
  required Color color,
  required VoidCallback onTap,
}) {
  return TactileCard(
    borderColor: color,
    onTap: onTap,
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
    child: Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(kColorTextPrimary),
          ),
        ),
        Text(
          range,
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: const Color(kColorTextSecondary),
          ),
        ),
      ],
    ),
  );
}
```

**Step 2: Add success counter header**

Add at the top of the technique section:

```dart
TactileCard(
  borderColor: const Color(kColorSecondary),
  child: Row(
    children: [
      const Text('🏆', style: TextStyle(fontSize: 32)),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '你已经成功应对 12 次',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '每多一次，你的大脑就更强一点',
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: const Color(kColorTextSecondary),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
```

**Step 3: Build and run**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -5`
Expected: Build succeeds

**Step 4: Commit**

```bash
git add lib/presentation/pages/urge_panel_page.dart
git commit -m "feat(urge): rebuild with semantic 3-choice intensity selector"
```

---

## Phase 4: Stats Page (P1)

### Task 4.1: Add Mood tracking entity and storage

**Files:**
- Create: `lib/data/repositories/mood_repository.dart`

**Step 1: Create MoodRepository**

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/mood_entry.dart';

class MoodRepository {
  static const _key = 'mood_entries';

  Future<List<MoodEntry>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => MoodEntry.fromJson(jsonDecode(s))).toList();
  }

  Future<void> save(MoodEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await loadAll();
    entries.removeWhere((e) =>
        e.date.year == entry.date.year &&
        e.date.month == entry.date.month &&
        e.date.day == entry.date.day);
    entries.add(entry);
    final raw = entries.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }
}
```

**Step 2: Commit**

```bash
git add lib/data/repositories/mood_repository.dart
git commit -m "feat(data): add MoodRepository for mood tracking"
```

---

### Task 4.2: Rebuild StatsPage with mood heatmap

**Files:**
- Modify: `lib/presentation/pages/progress_page.dart`

**Step 1: Add mood heatmap section**

Add at the top of the StatsPage body (after the existing stats cards):

```dart
TactileCard(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '心情热力图',
        style: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 16),
      DayWall(
        entries: List.generate(
          30,
          (i) => DayEntry(
            date: DateTime.now().subtract(Duration(days: 29 - i)),
            moodLevel: ((i * 7) % 5) + 1,
            hasRecord: i > 10,
          ),
        ),
      ),
    ],
  ),
),
```

**Step 2: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --debug 2>&1 | tail -5`
Expected: Build succeeds

**Step 3: Commit**

```bash
git add lib/presentation/pages/progress_page.dart
git commit -m "feat(stats): add mood heatmap to stats page"
```

---

## Phase 5: Onboarding (P1)

### Task 5.1: Create Welcome onboarding page

**Files:**
- Create: `lib/presentation/pages/onboarding/welcome_page.dart`

**Step 1: Create welcome page**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../widgets/tactile_card.dart';
import 'value_props_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(kColorPrimary), Color(kColorSecondary)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kPaddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  '🌊',
                  style: TextStyle(fontSize: 96),
                ),
                const SizedBox(height: 24),
                Text(
                  '你不是一个人在战斗',
                  style: GoogleFonts.nunito(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  '科学戒色，从这里开始',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    color: Colors.white.withAlpha(204),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                TactileCard(
                  backgroundColor: Colors.white,
                  borderColor: Colors.white,
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ValuePropsPage()),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  child: Text(
                    '开始',
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(kColorPrimary),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Step 2: Commit (placeholder for now)**

```bash
git add lib/presentation/pages/onboarding/
git commit -m "feat(onboarding): add welcome page"
```

---

## Phase 6: i18n Updates (P2)

### Task 6.1: Add new keys to all 6 ARB files

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_zh.arb`, `app_zh_Hant.arb`, `app_ja.arb`, `app_ko.arb`, `app_fr.arb`

**Step 1: Add to app_en.arb**

Add these keys:
```json
{
  "onboardingWelcome": "You are not alone",
  "onboardingSubtitle": "Scientific recovery starts here",
  "valueProp1Title": "Every urge passes in 90 seconds",
  "valueProp1Desc": "Your brain's reward system recalibrates with each passing wave",
  "valueProp2Title": "Your brain heals every day",
  "valueProp2Desc": "Neural pathways rebuild with each day you stay strong",
  "valueProp3Title": "Every step counts",
  "valueProp3Desc": "Your progress is permanent - never lost, always honored",
  "goalSetup": "Choose your goal",
  "day1Celebration": "Day 1 ✦ Begin",
  "urgeLevelLow": "Mild",
  "urgeLevelMid": "Strong",
  "urgeLevelHigh": "Overwhelming",
  "tryThis": "Try this first →",
  "swap": "Swap",
  "viewAll11": "View all 11 techniques",
  "brainRecovering": "Your brain is healing",
  "todaysRitual": "Today's Ritual",
  "morningCommitment": "Morning Commitment",
  "eveningReview": "Evening Review",
  "yourLevel": "Level",
  "xpEarned": "XP Earned",
  "achievements": "Achievements",
  "unlocked": "Unlocked",
  "locked": "Locked",
  "dayWall": "Mood Wall",
  "moodHeatmap": "Mood Heatmap",
  "triggerAnalysis": "Trigger Analysis",
  "milestone": "Milestone",
  "statsOverview": "Overview",
  "totalDays": "Total Days",
  "responseCount": "Responses",
  "longestStreak": "Longest Streak"
}
```

**Step 2: Add Chinese translations to app_zh.arb**

```json
{
  "onboardingWelcome": "你不是一个人在战斗",
  "onboardingSubtitle": "科学戒色，从这里开始",
  "valueProp1Title": "每个渴望都能用90秒度过",
  "valueProp1Desc": "你的大脑奖赏系统会随每一次浪潮重新校准",
  "valueProp2Title": "你的大脑每天都在恢复",
  "valueProp2Desc": "坚持每一天，你的神经通路都在重建",
  "valueProp3Title": "你已经走过的每一步，都算数",
  "valueProp3Desc": "你的进步是永久的 - 永远不会被遗忘",
  "goalSetup": "选择你的目标",
  "day1Celebration": "Day 1 ✦ 启程",
  "urgeLevelLow": "有点想",
  "urgeLevelMid": "很强烈",
  "urgeLevelHigh": "压不住",
  "tryThis": "先试试这个 →",
  "swap": "换一换",
  "viewAll11": "查看全部 11 个",
  "brainRecovering": "你的大脑正在恢复",
  "todaysRitual": "今日仪式",
  "morningCommitment": "早晨承诺",
  "eveningReview": "傍晚回顾",
  "yourLevel": "等级",
  "xpEarned": "获得经验",
  "achievements": "成就",
  "unlocked": "已解锁",
  "locked": "未解锁",
  "dayWall": "心情时间墙",
  "moodHeatmap": "心情热力图",
  "triggerAnalysis": "触发分析",
  "milestone": "里程碑",
  "statsOverview": "总览",
  "totalDays": "累计天数",
  "responseCount": "应对次数",
  "longestStreak": "最高连续"
}
```

**Step 3: Add similar translations to other 4 ARB files** (ja, ko, fr, zh_Hant)

**Step 4: Generate localizations**

Run: `~/flutter/flutter/bin/flutter gen-l10n`
Expected: Localizations generated successfully

**Step 5: Build to verify**

Run: `~/flutter/flutter/bin/flutter build macos --release 2>&1 | tail -5`
Expected: Build succeeds with all 6 languages

**Step 6: Commit**

```bash
git add lib/l10n/
git commit -m "feat(i18n): add 30+ new keys for V2.0 across 6 languages"
```

---

## Verification Checklist

Before marking the plan complete:

- [ ] Phase 1: All foundation widgets created (TactileCard, Pill, StepCounter, LevelBadge, DayWall)
- [ ] Phase 2: HomePage rebuilt with new design
- [ ] Phase 3: UrgePanel rebuilt with 3-choice selector
- [ ] Phase 4: StatsPage has mood heatmap
- [ ] Phase 5: Onboarding welcome page created
- [ ] Phase 6: All 30+ i18n keys added to 6 languages
- [ ] macOS build passes (`flutter build macos --release`)
- [ ] Visual verification: app runs with new green Lingo theme
- [ ] All commits are atomic and follow conventional commit style

---

## Out of Scope (Future Phases)

These are deferred to V2.1+:
- Brain recovery map animation
- Confetti celebration animation
- AI-powered cognitive reframing
- Achievement unlock animation
- Pull-to-refresh on stats
- Haptic feedback implementation
- Daily push notifications
- Personalized insights

---

**Plan complete.** Ready for execution.