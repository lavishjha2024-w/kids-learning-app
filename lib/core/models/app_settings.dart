import 'package:equatable/equatable.dart';

/// App settings model following HCI principles
class AppSettings extends Equatable {
  final int? userAge;
  final bool calmModeEnabled;
  final bool darkModeEnabled;
  final double fontSizeMultiplier; // 1.0 = base, 1.2 = 20% larger
  final bool colorblindModeEnabled;
  final bool dyslexiaFontEnabled;
  final bool soundEnabled;
  final bool musicEnabled;
  final double soundVolume;
  final int breakIntervalMinutes;
  final int breakDurationMinutes;
  final int? dailyUsageLimitMinutes; // null = no limit
  final String? parentPin;

  const AppSettings({
    this.userAge,
    this.calmModeEnabled = false,
    this.darkModeEnabled = false,
    this.fontSizeMultiplier = 1.0,
    this.colorblindModeEnabled = false,
    this.dyslexiaFontEnabled = false,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.soundVolume = 0.7,
    this.breakIntervalMinutes = 30,
    this.breakDurationMinutes = 5,
    this.dailyUsageLimitMinutes,
    this.parentPin,
  });

  Map<String, dynamic> toJson() => {
        'userAge': userAge,
        'calmModeEnabled': calmModeEnabled,
        'darkModeEnabled': darkModeEnabled,
        'fontSizeMultiplier': fontSizeMultiplier,
        'colorblindModeEnabled': colorblindModeEnabled,
        'dyslexiaFontEnabled': dyslexiaFontEnabled,
        'soundEnabled': soundEnabled,
        'musicEnabled': musicEnabled,
        'soundVolume': soundVolume,
        'breakIntervalMinutes': breakIntervalMinutes,
        'breakDurationMinutes': breakDurationMinutes,
        'dailyUsageLimitMinutes': dailyUsageLimitMinutes,
        'parentPin': parentPin,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        userAge: json['userAge'],
        calmModeEnabled: json['calmModeEnabled'] ?? false,
        darkModeEnabled: json['darkModeEnabled'] ?? false,
        fontSizeMultiplier: json['fontSizeMultiplier']?.toDouble() ?? 1.0,
        colorblindModeEnabled: json['colorblindModeEnabled'] ?? false,
        dyslexiaFontEnabled: json['dyslexiaFontEnabled'] ?? false,
        soundEnabled: json['soundEnabled'] ?? true,
        musicEnabled: json['musicEnabled'] ?? true,
        soundVolume: json['soundVolume']?.toDouble() ?? 0.7,
        breakIntervalMinutes: json['breakIntervalMinutes'] ?? 30,
        breakDurationMinutes: json['breakDurationMinutes'] ?? 5,
        dailyUsageLimitMinutes: json['dailyUsageLimitMinutes'],
        parentPin: json['parentPin'],
      );

  AppSettings copyWith({
    int? userAge,
    bool? calmModeEnabled,
    bool? darkModeEnabled,
    double? fontSizeMultiplier,
    bool? colorblindModeEnabled,
    bool? dyslexiaFontEnabled,
    bool? soundEnabled,
    bool? musicEnabled,
    double? soundVolume,
    int? breakIntervalMinutes,
    int? breakDurationMinutes,
    int? dailyUsageLimitMinutes,
    String? parentPin,
  }) {
    return AppSettings(
      userAge: userAge ?? this.userAge,
      calmModeEnabled: calmModeEnabled ?? this.calmModeEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
      colorblindModeEnabled:
          colorblindModeEnabled ?? this.colorblindModeEnabled,
      dyslexiaFontEnabled: dyslexiaFontEnabled ?? this.dyslexiaFontEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      breakIntervalMinutes: breakIntervalMinutes ?? this.breakIntervalMinutes,
      breakDurationMinutes: breakDurationMinutes ?? this.breakDurationMinutes,
      dailyUsageLimitMinutes:
          dailyUsageLimitMinutes ?? this.dailyUsageLimitMinutes,
      parentPin: parentPin ?? this.parentPin,
    );
  }

  @override
  List<Object?> get props => [
        userAge,
        calmModeEnabled,
        darkModeEnabled,
        fontSizeMultiplier,
        colorblindModeEnabled,
        dyslexiaFontEnabled,
        soundEnabled,
        musicEnabled,
        soundVolume,
        breakIntervalMinutes,
        breakDurationMinutes,
        dailyUsageLimitMinutes,
        parentPin,
      ];
}
