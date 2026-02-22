import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/providers/settings_provider.dart';
import 'presentation/providers/usage_tracker_provider.dart';
import 'core/utils/break_reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  runApp(
    const ProviderScope(
      child: KidsLearningApp(),
    ),
  );
}

class KidsLearningApp extends ConsumerWidget {
  const KidsLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final hasCompletedOnboarding = settings.userAge != null;

    return MaterialApp(
      title: 'Kids Learning App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.darkModeEnabled
          ? ThemeMode.dark
          : ThemeMode.light,
      home: hasCompletedOnboarding
          ? const MainScreenWrapper()
          : const OnboardingScreen(),
    );
  }
}

/// Wrapper to initialize services when app starts
class MainScreenWrapper extends ConsumerStatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  ConsumerState<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends ConsumerState<MainScreenWrapper>
    with WidgetsBindingObserver {
  BreakReminderService? _breakReminderService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
  }

  void _initializeServices() {
    _breakReminderService = ref.read(breakReminderServiceProvider);
    _breakReminderService?.startSession();
    
    // Start usage tracking
    ref.read(usageTrackerProvider.notifier).startSession(null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final usageTracker = ref.read(usageTrackerProvider.notifier);
    
    if (state == AppLifecycleState.paused) {
      // App went to background - end session
      usageTracker.endSession();
      _breakReminderService?.stop();
    } else if (state == AppLifecycleState.resumed) {
      // App resumed - start new session
      usageTracker.startSession(null);
      _breakReminderService?.startSession();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(usageTrackerProvider.notifier).endSession();
    _breakReminderService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MainScreen();
  }
}
