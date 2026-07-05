import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/log/app_logger.dart';
import 'data/datasources/local_datasource.dart';
import 'presentation/blocs/abstinence_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/onboarding/splash_page.dart';
import 'presentation/pages/progress_page.dart';
import 'presentation/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLogger.instance.init();
  await LocalDataSource.instance.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.instance.info('=== 清流 V3.0 Started ===', tag: 'Main');

  runApp(const QingliuApp());
}

class QingliuApp extends StatelessWidget {
  const QingliuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '清流',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (var supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return supportedLocales.first;
      },
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
        Locale('zh', 'Hant'),
        Locale('ja'),
        Locale('fr'),
        Locale('ko'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const _RootGate(),
    );
  }
}

/// Root gate: splash (if first time) → main shell
class _RootGate extends StatefulWidget {
  const _RootGate();
  @override
  State<_RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<_RootGate> {
  bool _loading = true;
  bool _onboardingComplete = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBF8F1),
        body: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: const Color(0xFF0071E3),
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }
    // If onboarding not complete, splash handles its own bloc internally.
    // If complete, wrap main shell with bloc.
    if (!_onboardingComplete) {
      return BlocProvider(
        create: (_) => AbstinenceBloc()..add(AbstinenceLoadRequested()),
        child: const SplashPage(),
      );
    }
    return BlocProvider(
      create: (_) => AbstinenceBloc()..add(AbstinenceLoadRequested()),
      child: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    ProgressPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFE3D9C4).withAlpha(128),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, '首页'),
                _buildNavItem(1, Icons.bar_chart_outlined, Icons.bar_chart, '进展'),
                _buildNavItem(2, Icons.settings_outlined, Icons.settings, '设置'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? const Color(0xFF0071E3)
                  : const Color(0xFF8B7E6E),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0071E3)
                    : const Color(0xFF8B7E6E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}