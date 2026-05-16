# 清流 (Qingliu)

> A scientific habit-building app for healthy lifestyle choices.

[English](#english) | [中文](#中文)

---

## English

### Overview

**Qingliu** is a Flutter-based desktop/mobile app designed to help users build healthy habits through science-backed techniques and structured goal-tracking. Originally developed for behavioral recovery, it combines neuroscience principles with practical exercises to help users resist urges and maintain streaks.

### Features

- **Goal Tracking** — Start 30-day or 90-day abstinence challenges with visual progress
- **Urge Response Panel** — Smart recommendation engine suggests techniques based on urge intensity (1-10 scale)
  - Top 5 techniques shown by default, expandable for more
  - "Random Draw" gacha feature for indecisive moments
  - Cognitive reframing section to log thoughts
- **11 Evidence-Based Techniques**:
  | Technique | Duration | Best For |
  |-----------|----------|----------|
  | 90-Second Breathing | 90s | Urge levels 3-10 |
  | 5-4-3-2-1 Grounding | 60s | Urge levels 2-8 |
  | Cold Water Face Wash | 30s | Quick interrupt |
  | Cold Water + Self-Talk | 45s | Urge levels 5-10 |
  | 20 Squats | 45s | Moderate urges |
  | ...and 6 more | | |
- **Milestone System** — Celebrate neural recovery milestones with confetti animations
- **Relapse Analysis** — Post-relapse journaling with structured questions
- **Statistics** — Weekly stats, longest streak, successful resists
- **Multi-Language** — Supports EN, ZH, ZH-Hant, JA, KO, FR

### Tech Stack

- **Flutter** — Cross-platform UI framework
- **Dart** — Language
- **Provider** — State management
- **SharedPreferences** — Local data persistence
- **flutter_localizations** — i18n support

### Getting Started

#### Prerequisites

- Flutter SDK (≥ 3.0)
- Xcode (for macOS builds)
- Android Studio (for Android builds)

#### Build

```bash
# Clone
git clone <repo-url>
cd qingliu

# Get dependencies
flutter pub get

# Run (debug)
flutter run

# Build macOS
flutter build macos --release

# Build Android
flutter build apk --release
```

#### Project Structure

```
lib/
├── core/
│   ├── constants/       # App-wide constants (colors, dimensions)
│   ├── theme/           # Light/dark theme definitions
│   └── log/             # Logging utilities
├── data/
│   ├── models/          # Data models
│   └── repositories/    # Data access layer
├── domain/
│   └── entities/        # Business entities (UrgeTechnique, etc.)
├── l10n/                # Localization ARB files
│   ├── app_en.arb
│   ├── app_zh.arb
│   └── ...
├── presentation/
│   ├── pages/           # Full-page screens
│   ├── widgets/          # Reusable UI components
│   └── animations/       # Animation utilities
└── main.dart
```

### Urge Level Scoring

Techniques are sorted using a scoring algorithm:

```
baseScore = 100 - displayPriority
if (urgeLevel >= min && urgeLevel <= max):
    baseScore += 50
    if (recommendedUrgeLevel == urgeLevel):
        baseScore += 30
    else:
        baseScore -= abs(recommendedUrgeLevel - urgeLevel) * 3
else:
    baseScore -= 100
```

### Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

### License

MIT License

---

## 中文

### 简介

**清流** 是一款基于 Flutter 开发的科学习惯养成应用，旨在帮助用户通过科学验证的方法建立健康的生活方式。应用融合了神经科学原理与实用技巧，帮助用户应对渴望、保持连续记录。

### 主要功能

- **目标追踪** — 开启30天或90天戒断挑战，可视化进度展示
- **渴望应对面板** — 智能推荐系统，根据渴望强度（1-10级）推荐最合适的技术
  - 默认显示前5名技术，支持展开查看全部
  - "随机抽卡"功能，选择困难时的好帮手
  - 认知重构区域，记录当下想法
- **11种循证技术**：
  | 技术 | 时长 | 适用强度 |
  |------|------|----------|
  | 90秒呼吸法 | 90秒 | 强度 3-10 |
  | 感官接地54321 | 60秒 | 强度 2-8 |
  | 冷水洗脸30秒 | 30秒 | 快速打断 |
  | 冷水+自我对话 | 45秒 | 强度 5-10 |
  | 20个深蹲 | 45秒 | 中等渴望 |
  | ...还有6种更多 | | |
- **里程碑系统** — 庆祝神经恢复里程碑，配有彩纸动画
- **破戒分析** — 结构化复盘问卷，帮助从失败中学习
- **统计数据** — 本周统计、最长连续、成功应对次数
- **多语言支持** — 中文、英文、繁体中文、日语、韩语、法语

### 技术栈

- **Flutter** — 跨平台UI框架
- **Dart** — 编程语言
- **Provider** — 状态管理
- **SharedPreferences** — 本地数据持久化
- **flutter_localizations** — 国际化支持

### 快速开始

#### 环境要求

- Flutter SDK (≥ 3.0)
- Xcode（用于 macOS 构建）
- Android Studio（用于 Android 构建）

#### 构建命令

```bash
# 克隆仓库
git clone <repo-url>
cd qingliu

# 安装依赖
flutter pub get

# 运行（调试模式）
flutter run

# 构建 macOS
flutter build macos --release

# 构建 Android
flutter build apk --release
```

#### 项目结构

```
lib/
├── core/
│   ├── constants/       # 全局常量（颜色、尺寸）
│   ├── theme/           # 亮色/暗色主题定义
│   └── log/             # 日志工具
├── data/
│   ├── models/          # 数据模型
│   └── repositories/    # 数据访问层
├── domain/
│   └── entities/        # 业务实体（如 UrgeTechnique）
├── l10n/                # 国际化 ARB 文件
│   ├── app_en.arb
│   ├── app_zh.arb
│   └── ...
├── presentation/
│   ├── pages/           # 整页屏幕
│   ├── widgets/          # 可复用UI组件
│   └── animations/       # 动画工具
└── main.dart
```

### 渴望强度评分算法

技术排序使用以下评分算法：

```
基础分 = 100 - 显示优先级
如果（渴望强度 >= 最小强度 && 渴望强度 <= 最大强度）：
    基础分 += 50
    如果（推荐强度 == 当前渴望强度）：
        基础分 += 30
    否则：
        基础分 -= abs(推荐强度 - 当前渴望强度) * 3
否则：
    基础分 -= 100
```

### 参与贡献

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/my-feature`)
3. 提交更改
4. 推送到分支
5. 发起 Pull Request

### 许可证

MIT License