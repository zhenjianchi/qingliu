import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/log/app_logger.dart';
import 'data/datasources/local_datasource.dart';
import 'presentation/blocs/abstinence_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/progress_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/urge_panel_page.dart';
import 'presentation/pages/trigger_log_page.dart';
import 'presentation/pages/technique_guide_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  await AppLogger.instance.init();

  // Initialize local data source
  await LocalDataSource.instance.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.instance.info('=== 清流 App Started ===', tag: 'Main');

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
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (_) => AbstinenceBloc()..add(AbstinenceLoadRequested()),
        child: const MainShell(),
      ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: '进度',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}