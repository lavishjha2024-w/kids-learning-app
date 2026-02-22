import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/models/usage_data.dart';
import '../../core/constants/app_constants.dart';

/// Provider for tracking usage following mental health principles
final usageTrackerProvider =
    StateNotifierProvider<UsageTrackerNotifier, List<UsageData>>((ref) {
  return UsageTrackerNotifier();
});

class UsageTrackerNotifier extends StateNotifier<List<UsageData>> {
  UsageTrackerNotifier() : super([]) {
    _loadUsageData();
  }

  Future<void> _loadUsageData() async {
    final prefs = await SharedPreferences.getInstance();
    final usageJson = prefs.getString(AppConstants.storageKeyUsageData);
    if (usageJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(usageJson);
        state = decoded.map((json) => UsageData.fromJson(json)).toList();
      } catch (e) {
        state = [];
      }
    }
  }

  Future<void> _saveUsageData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.storageKeyUsageData,
      jsonEncode(state.map((u) => u.toJson()).toList()),
    );
  }

  /// Start a new session
  Future<void> startSession(String? moduleId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Find or create today's usage data
    final todayIndex = state.indexWhere(
      (data) => data.date.year == today.year &&
          data.date.month == today.month &&
          data.date.day == today.day,
    );

    final session = SessionData(
      startTime: now,
      duration: Duration.zero,
      moduleId: moduleId,
    );

    if (todayIndex >= 0) {
      // Update existing day
      final todayData = state[todayIndex];
      final updatedSessions = [...todayData.sessions, session];
      state = [
        ...state.sublist(0, todayIndex),
        todayData.copyWith(
          sessionCount: todayData.sessionCount + 1,
          sessions: updatedSessions,
        ),
        ...state.sublist(todayIndex + 1),
      ];
    } else {
      // Create new day
      state = [
        ...state,
        UsageData(
          date: today,
          totalUsageTime: Duration.zero,
          sessionCount: 1,
          sessions: [session],
          moduleUsage: {},
          engagementScore: 3,
        ),
      ];
    }

    await _saveUsageData();
  }

  /// End current session
  Future<void> endSession() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final todayIndex = state.indexWhere(
      (data) => data.date.year == today.year &&
          data.date.month == today.month &&
          data.date.day == today.day,
    );

    if (todayIndex >= 0 && state[todayIndex].sessions.isNotEmpty) {
      final todayData = state[todayIndex];
      final sessions = List<SessionData>.from(todayData.sessions);
      
      if (sessions.isNotEmpty) {
        final lastSession = sessions.last;
        final duration = now.difference(lastSession.startTime);
        
        sessions[sessions.length - 1] = SessionData(
          startTime: lastSession.startTime,
          endTime: now,
          duration: duration,
          moduleId: lastSession.moduleId,
        );

        // Update total usage time
        final totalTime = todayData.totalUsageTime + duration;
        
        // Update module usage
        final moduleUsage = Map<String, int>.from(todayData.moduleUsage);
        if (lastSession.moduleId != null) {
          moduleUsage[lastSession.moduleId!] =
              (moduleUsage[lastSession.moduleId!] ?? 0) +
                  duration.inMinutes;
        }

        state = [
          ...state.sublist(0, todayIndex),
          todayData.copyWith(
            totalUsageTime: totalTime,
            sessions: sessions,
            moduleUsage: moduleUsage,
          ),
          ...state.sublist(todayIndex + 1),
        ];

        await _saveUsageData();
      }
    }
  }

  /// Get today's usage
  UsageData? getTodayUsage() {
    final today = DateTime.now();
    return state.firstWhere(
      (data) =>
          data.date.year == today.year &&
          data.date.month == today.month &&
          data.date.day == today.day,
      orElse: () => UsageData(
        date: today,
        totalUsageTime: Duration.zero,
        sessionCount: 0,
        sessions: [],
        moduleUsage: {},
        engagementScore: 3,
      ),
    );
  }

  /// Get weekly usage summary
  List<UsageData> getWeeklyUsage() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    return state.where((data) {
      return data.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          data.date.isBefore(now.add(const Duration(days: 1)));
    }).toList();
  }
}
