import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../constants/app_constants.dart';
import '../../presentation/providers/settings_provider.dart';

/// Service for managing break reminders following mental health principles
class BreakReminderService {
  Timer? _breakTimer;
  Timer? _sessionTimer;
  DateTime? _sessionStartTime;
  final Ref _ref;

  BreakReminderService(this._ref);

  /// Start tracking session time
  void startSession() {
    _sessionStartTime = DateTime.now();
    _startBreakTimer();
  }

  void _startBreakTimer() {
    _breakTimer?.cancel();
    
    final settings = _ref.read(settingsProvider);
    final interval = Duration(minutes: settings.breakIntervalMinutes);

    _breakTimer = Timer(interval, () {
      // Break time reached
      _onBreakTime();
    });
  }

  void _onBreakTime() {
    // This will be handled by the UI layer
    // The service just tracks time
  }

  /// Reset break timer (called after break is taken)
  void resetBreakTimer() {
    _sessionStartTime = DateTime.now();
    _startBreakTimer();
  }

  /// Get time until next break
  Duration? getTimeUntilBreak() {
    if (_sessionStartTime == null || _breakTimer == null) return null;
    
    final settings = _ref.read(settingsProvider);
    final interval = Duration(minutes: settings.breakIntervalMinutes);
    final elapsed = DateTime.now().difference(_sessionStartTime!);
    
    if (elapsed >= interval) {
      return Duration.zero; // Break time!
    }
    
    return interval - elapsed;
  }

  /// Stop all timers
  void stop() {
    _breakTimer?.cancel();
    _sessionTimer?.cancel();
    _breakTimer = null;
    _sessionTimer = null;
    _sessionStartTime = null;
  }

  void dispose() {
    stop();
  }
}

/// Provider for break reminder service
final breakReminderServiceProvider = Provider<BreakReminderService>((ref) {
  final service = BreakReminderService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});
