# Setup Guide

## Prerequisites

1. **Flutter SDK**: Install Flutter (latest stable version)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **IDE**: Recommended IDEs
   - Android Studio / IntelliJ IDEA (with Flutter plugin)
   - VS Code (with Flutter extension)
   - Cursor (current IDE)

## Installation Steps

1. **Clone/Navigate to the project**
   ```bash
   cd KidsApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for Riverpod generators)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── models/             # Data models
│   ├── theme/              # Theme configuration
│   └── utils/              # Utility services
├── data/                   # Data layer (repositories, datasources)
├── domain/                 # Domain layer (entities, use cases)
└── presentation/
    ├── providers/          # Riverpod state providers
    ├── screens/            # App screens
    └── widgets/            # Reusable widgets

assets/
├── images/                 # Image assets
├── animations/             # Lottie animations
├── audio/                  # Audio files
└── fonts/                  # Custom fonts
```

## Key Features

### Learning Modules
- **Alphabets**: A-Z with voice guidance
- **Numbers**: 1-10 with visual counting
- **Math**: Basic addition and subtraction
- **Shapes**: Common shapes with descriptions
- **Puzzles**: Simple puzzle games (coming soon)
- **Memory**: Card matching game
- **Stories**: Interactive stories (coming soon)

### Mental Health Features
- **Break Reminders**: Automatic reminders every 30 minutes
- **Usage Tracking**: Daily and weekly analytics
- **Calm Mode**: Reduced animations and sounds
- **Positive Reinforcement**: Effort-based encouragement

### Parent Controls
- **PIN Protection**: Secure parent panel
- **Usage Limits**: Set daily time limits
- **Break Settings**: Customize break intervals
- **Content Controls**: Manage sounds and features

### Accessibility
- **Text-to-Speech**: All learning content narrated
- **Font Size**: Adjustable (0.8x to 1.5x)
- **Colorblind Mode**: Colorblind-friendly colors
- **Dyslexia Font**: Easier-to-read font option

## Configuration

### First Launch
1. Complete onboarding (select age)
2. App will remember your preferences
3. Access parent controls from Settings

### Parent PIN Setup
1. Go to Settings → Parent Controls
2. Set a 4-6 digit PIN
3. Use PIN to access parent panel

## Development Notes

### State Management
- Uses **Riverpod** for state management
- Providers in `lib/presentation/providers/`
- Settings persist using SharedPreferences

### Local Storage
- **SharedPreferences**: Settings and user data
- **Hive**: Future expansion for complex data

### Theme System
- Light and dark themes
- Eye-friendly color palette
- Customizable font sizes
- Colorblind and dyslexia support

## Testing

### Manual Testing Checklist
- [ ] Onboarding flow works
- [ ] All learning modules load
- [ ] Text-to-speech functions
- [ ] Break reminders appear
- [ ] Parent controls require PIN
- [ ] Settings persist after app restart
- [ ] Dark mode works
- [ ] Font size adjustment works
- [ ] Navigation is intuitive

### Device Testing
- Test on both phone and tablet
- Verify touch targets are large enough
- Check text readability
- Test with different screen sizes

## Troubleshooting

### Common Issues

1. **Flutter not found**
   - Ensure Flutter is in your PATH
   - Run `flutter doctor` to check setup

2. **Dependencies not installing**
   - Run `flutter clean`
   - Delete `pubspec.lock`
   - Run `flutter pub get` again

3. **Build errors**
   - Run `flutter pub run build_runner build --delete-conflicting-outputs`
   - Check Flutter version compatibility

4. **Text-to-speech not working**
   - Check device permissions
   - Verify language support
   - Test on physical device (not all emulators support TTS)

## Next Steps

### Future Enhancements
- [ ] Complete puzzle module
- [ ] Add story content
- [ ] More learning modules
- [ ] Progress badges (effort-based)
- [ ] Character companion
- [ ] Offline mode improvements

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [HCI Principles Guide](./HCI_PRINCIPLES.md)
- [Project README](./README.md)
