import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../constants/app_constants.dart';
import '../../presentation/providers/settings_provider.dart';

/// Text-to-speech service following accessibility principles
class TextToSpeechService {
  final FlutterTts _tts = FlutterTts();
  final Ref _ref;

  TextToSpeechService(this._ref);

  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5); // Slower for kids
    await _updateVolume();
  }

  Future<void> _updateVolume() async {
    final settings = _ref.read(settingsProvider);
    final volume = settings.calmModeEnabled
        ? AppConstants.calmModeVolume
        : settings.soundVolume;
    await _tts.setVolume(volume);
  }

  Future<void> speak(String text) async {
    final settings = _ref.read(settingsProvider);
    if (!settings.soundEnabled) return;

    await _updateVolume();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}

/// Provider for text-to-speech service
final textToSpeechServiceProvider = Provider<TextToSpeechService>((ref) {
  final service = TextToSpeechService(ref);
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});
