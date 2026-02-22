# Kids Learning Flutter App

A Flutter-based mobile learning app for kids (Age 4–10) that strictly follows Human-Computer Interaction (HCI) principles, emphasizing child-friendly UI/UX, cognitive load reduction, eye-friendly design, and mental health support.

## 🎯 Features

### Core HCI Principles Implemented
- ✅ Consistency across all screens
- ✅ Visibility of system status
- ✅ Immediate feedback for all actions
- ✅ Error prevention and recovery
- ✅ Recognition over recall (icons + labels)
- ✅ Minimal cognitive load
- ✅ User control and freedom
- ✅ Accessibility features
- ✅ Flexibility and efficiency
- ✅ Aesthetic & minimalist design

### Learning Modules
- Alphabets with voice guidance
- Numbers & counting
- Basic math (interactive)
- Shapes and colors
- Simple puzzles
- Memory matching game
- Story mode with narration

### Mental Health Features
- Break reminder system (30-minute intervals)
- Smart usage tracking
- Calm mode (reduced animations/sounds)
- Positive reinforcement system
- Parent control panel

### Accessibility
- Text-to-speech
- Adjustable font size
- Dyslexia-friendly font option
- Colorblind-friendly mode
- Voice navigation option

## 🏗️ Architecture

Clean Architecture with three layers:
- **Presentation**: UI components, screens, widgets
- **Domain**: Business logic, entities, use cases
- **Data**: Repositories, data sources, models

## 📱 Getting Started

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

3. Generate code (for Riverpod generators):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🎨 Design Principles

- Soft pastel colors (light blue, mint green, lavender, peach)
- Warm off-white background (#FAF9F6)
- Large rounded fonts (minimum 16–20px)
- Large tappable buttons (minimum 48dp height)
- Generous padding and spacing
- Optional Dark Mode (soft dark theme)
