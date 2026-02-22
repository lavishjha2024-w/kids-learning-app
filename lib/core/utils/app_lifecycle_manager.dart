import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/break_reminder_service.dart';
import '../../presentation/providers/usage_tracker_provider.dart';

/// Manages app lifecycle to track usage and manage break reminders
class AppLifecycleManager extends ConsumerStatefulWidget {
  final Widget child;

  const AppLifecycleManager({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AppLifecycleManager> createState() =>
      _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends ConsumerState<AppLifecycleManager>
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
    ref.read(usageTrackerProvider.notifier).startSession(null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final usageTracker = ref.read(usageTrackerProvider.notifier);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App went to background - end session
        usageTracker.endSession();
        _breakReminderService?.stop();
        break;
      case AppLifecycleState.resumed:
        // App resumed - start new session
        usageTracker.startSession(null);
        _breakReminderService?.startSession();
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        usageTracker.endSession();
        _breakReminderService?.stop();
        break;
      case AppLifecycleState.hidden:
        // App is hidden (iOS specific)
        break;
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
    return widget.child;
  }
}
