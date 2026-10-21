import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/config/app_config.dart';
import 'database/database.dart';
import 'features/onboarding/settings_first_launch_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/journal/journal_list_screen.dart';
import 'features/journal/journal_editor_screen.dart';
import 'features/report/report_screen.dart';
import 'features/report/report_preview_screen.dart';
import 'features/jury/jury_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/ai/model_manager_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(ProviderScope(
    overrides: [databaseProvider.overrideWithValue(db)],
    child: const RapportPlusApp(),
  ));
}

final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError());
final firstLaunchProvider = FutureProvider<bool>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.isFirstLaunch();
});

class RapportPlusApp extends ConsumerWidget {
  const RapportPlusApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstLaunchAsync = ref.watch(firstLaunchProvider);
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
        Locale('ar', 'TN'),
      ],
      locale: const Locale('fr', 'FR'),
      routerConfig: _buildRouter(firstLaunchAsync),
    );
  }

  GoRouter _buildRouter(AsyncValue<bool> firstLaunch) {
    return GoRouter(
      initialLocation: firstLaunch.value == true ? '/settings-first' : '/dashboard',
      redirect: (context, state) {
        if (firstLaunch.value == true && state.matchedLocation != '/settings-first') return '/settings-first';
        return null;
      },
      routes: [
        GoRoute(path: '/settings-first', builder: (c, s) => const SettingsFirstLaunchScreen()),
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen()),
            GoRoute(path: '/journal', builder: (c, s) => const JournalListScreen()),
            GoRoute(path: '/journal/new', builder: (c, s) => const JournalEditorScreen()),
            GoRoute(path: '/journal/:id', builder: (c, s) => JournalEditorScreen(entryId: int.tryParse(s.pathParameters['id']!))),
            GoRoute(path: '/report', builder: (c, s) => const ReportScreen()),
            GoRoute(path: '/report/preview', builder: (c, s) => const ReportPreviewScreen()),
            GoRoute(path: '/soutenance', builder: (c, s) => const JuryScreen()),
            GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
            GoRoute(path: '/ai/models', builder: (c, s) => const ModelManagerScreen()),
          ],
        ),
      ],
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _indexForLocation(String loc) {
    if (loc.startsWith('/dashboard')) return 0;
    if (loc.startsWith('/journal')) return 1;
    if (loc.startsWith('/report')) return 2;
    if (loc.startsWith('/soutenance')) return 3;
    if (loc.startsWith('/settings') || loc.startsWith('/ai')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    final idx = _indexForLocation(loc);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkScaffold : Colors.white,
          border: Border(top: BorderSide(color: isDark ? AppTheme.darkLine : AppTheme.line, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) {
            switch (i) {
              case 0: context.go('/dashboard'); break;
              case 1: context.go('/journal'); break;
              case 2: context.go('/report'); break;
              case 3: context.go('/soutenance'); break;
              case 4: context.go('/settings'); break;
            }
          },
          backgroundColor: isDark ? AppTheme.darkScaffold : Colors.white,
          indicatorColor: isDark ? Colors.white : AppTheme.ink,
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: Colors.white), label: 'Accueil'),
            NavigationDestination(icon: Icon(Icons.article_outlined), selectedIcon: Icon(Icons.article, color: Colors.white), label: 'Journal'),
            NavigationDestination(icon: Icon(Icons.description_outlined), selectedIcon: Icon(Icons.description, color: Colors.white), label: 'Rapport'),
            NavigationDestination(icon: Icon(Icons.mic_none), selectedIcon: Icon(Icons.mic, color: Colors.white), label: 'Soutenance'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings, color: Colors.white), label: 'Réglages'),
          ],
        ),
      ),
    );
  }
}
