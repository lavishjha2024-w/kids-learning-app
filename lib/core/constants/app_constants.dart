/// Application-wide constants following HCI principles

class AppConstants {
  // Break reminder settings
  static const int defaultBreakIntervalMinutes = 30;
  static const int defaultBreakDurationMinutes = 5;
  
  // Touch target sizes (Fitts's Law - minimum 48dp)
  static const double minTouchTargetSize = 48.0;
  static const double buttonHeight = 56.0;
  static const double iconButtonSize = 56.0;
  
  // Spacing (generous padding)
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  
  // Font sizes (minimum 16-20px base)
  static const double fontSizeSmall = 14.0;
  static const double fontSizeBase = 18.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 28.0;
  
  // Border radius (rounded, friendly)
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusXLarge = 24.0;
  
  // Animation durations (smooth, not overwhelming)
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 400);
  static const Duration animationDurationSlow = Duration(milliseconds: 600);
  
  // Age groups
  static const int minAge = 4;
  static const int maxAge = 10;
  
  // Storage keys
  static const String storageKeyUserAge = 'user_age';
  static const String storageKeyParentPin = 'parent_pin';
  static const String storageKeyUsageData = 'usage_data';
  static const String storageKeyProgress = 'learning_progress';
  static const String storageKeySettings = 'app_settings';
  static const String storageKeyCalmMode = 'calm_mode_enabled';
  static const String storageKeyDarkMode = 'dark_mode_enabled';
  static const String storageKeyFontSize = 'font_size_multiplier';
  static const String storageKeyColorblindMode = 'colorblind_mode';
  
  // Audio settings
  static const double defaultVolume = 0.7;
  static const double calmModeVolume = 0.4;
  
  // Learning module IDs
  static const String moduleAlphabets = 'alphabets';
  static const String moduleNumbers = 'numbers';
  static const String moduleMath = 'math';
  static const String moduleShapes = 'shapes';
  static const String modulePuzzles = 'puzzles';
  static const String moduleMemory = 'memory';
  static const String moduleStories = 'stories';
}
