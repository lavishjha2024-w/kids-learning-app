import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/models/app_settings.dart';
import '../../core/constants/app_constants.dart';

/// Provider for app settings following HCI principles
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(AppConstants.storageKeySettings);
    if (settingsJson != null) {
      try {
        state = AppSettings.fromJson(jsonDecode(settingsJson));
      } catch (e) {
        // If parsing fails, use defaults
        state = const AppSettings();
      }
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.storageKeySettings,
      jsonEncode(state.toJson()),
    );
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    state = newSettings;
    await _saveSettings();
  }

  Future<void> setUserAge(int age) async {
    state = state.copyWith(userAge: age);
    await _saveSettings();
  }

  Future<void> toggleCalmMode() async {
    state = state.copyWith(calmModeEnabled: !state.calmModeEnabled);
    await _saveSettings();
  }

  Future<void> toggleDarkMode() async {
    state = state.copyWith(darkModeEnabled: !state.darkModeEnabled);
    await _saveSettings();
  }

  Future<void> setFontSizeMultiplier(double multiplier) async {
    state = state.copyWith(fontSizeMultiplier: multiplier);
    await _saveSettings();
  }

  Future<void> toggleColorblindMode() async {
    state = state.copyWith(colorblindModeEnabled: !state.colorblindModeEnabled);
    await _saveSettings();
  }

  Future<void> toggleDyslexiaFont() async {
    state = state.copyWith(dyslexiaFontEnabled: !state.dyslexiaFontEnabled);
    await _saveSettings();
  }

  Future<void> setBreakInterval(int minutes) async {
    state = state.copyWith(breakIntervalMinutes: minutes);
    await _saveSettings();
  }

  Future<void> setBreakDuration(int minutes) async {
    state = state.copyWith(breakDurationMinutes: minutes);
    await _saveSettings();
  }

  Future<void> setDailyUsageLimit(int? minutes) async {
    state = state.copyWith(dailyUsageLimitMinutes: minutes);
    await _saveSettings();
  }

  Future<void> setParentPin(String pin) async {
    state = state.copyWith(parentPin: pin);
    await _saveSettings();
  }

  Future<void> toggleSound() async {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
    await _saveSettings();
  }

  Future<void> toggleMusic() async {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
    await _saveSettings();
  }

  Future<void> setSoundVolume(double volume) async {
    state = state.copyWith(soundVolume: volume);
    await _saveSettings();
  }
}
