# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - MVP - TBD

### Added
- Initial project structure with Clean Architecture
- Core module: constants, theme, utils, logging
- Data layer: SQLite local storage with encrypted option
- Domain layer: entities, repositories, use cases
- Presentation layer: BLoC state management, pages, widgets
- **戒断计时器** (Abstinence Timer) - core data anchor with milestone tracking
- **渴望应对面板** (Urge Response Panel) - 11 neuroscience-backed interrupt techniques
  - T1: 冷水激活 (Cold Water Activation)
  - T2: 爆发性运动 (Burst Exercise)
  - T3: 强薄荷味觉打断 (Strong Mint Sensory Override)
  - T4: 90秒呼吸重启 (90-sec Breathing Reset)
  - T5: 感官接地54321 (Sensory Grounding 5-4-3-2-1)
  - T6: 冷热交替 (Cold-Hot Alternating)
  - T7: 冰敷后颈 (Ice Pack Neck Application)
  - T8: 屏息冲刺 (Breath-Hold Sprint)
  - T9: 冷水浸泡手腕 (Cold Water Wrist Soak)
  - T10: 强震感换场 (Strong Vibration Switch)
  - T11: 冷水洗脸+自我对话 (Cold Face Wash + Self-Dialogue)
- **触发日志** (Trigger Log) - quick entry with emotion tracking
- **风险感知** (Risk Perception) - local algorithm-based risk period detection
- **进度报告** (Progress Report) - daily summary, weekly report, milestone celebration
- **预测性干预** (Predictive Intervention) - non-intrusive notification system
- Git repository initialization with .gitignore
- Comprehensive logging module for debugging

### Features
- Offline-first architecture, all data stored locally via SQLite
- Privacy-first design: no cloud sync, no third-party tracking
- Relapse handling: supportive recovery flow, no punishment
- Milestone system: 7/14/30/60/90/180 days with badge rewards
- Color scheme: Deep Blue (#1F3A5F) + Light Blue (#4472C4) + Mint Green (#4CAF50)