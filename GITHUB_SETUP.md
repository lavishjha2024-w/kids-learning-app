# GitHub Setup & Running Guide

## 📤 Step 1: Push to GitHub

### Option A: Create New Repository on GitHub (Recommended)

1. **Create a new repository on GitHub:**
   - Go to https://github.com/new
   - Repository name: `kids-learning-app` (or your preferred name)
   - Description: "Flutter-based kids learning app with HCI principles"
   - Choose **Public** or **Private**
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
   - Click "Create repository"

2. **Initialize Git and Push:**
   ```bash
   cd /Users/lavish/KidsApp
   
   # Initialize git (if not already done)
   git init
   
   # Add all files
   git add .
   
   # Create initial commit
   git commit -m "Initial commit: Kids Learning Flutter App with HCI principles"
   
   # Add GitHub remote (replace YOUR_USERNAME with your GitHub username)
   git remote add origin https://github.com/YOUR_USERNAME/kids-learning-app.git
   
   # Rename branch to main (if needed)
   git branch -M main
   
   # Push to GitHub
   git push -u origin main
   ```

### Option B: Use GitHub CLI (if installed)

```bash
cd /Users/lavish/KidsApp
gh repo create kids-learning-app --public --source=. --remote=origin --push
```

### Option C: Manual Git Commands

```bash
cd /Users/lavish/KidsApp

# Check git status
git status

# Add all files
git add .

# Commit
git commit -m "Initial commit: Kids Learning Flutter App"

# Add remote (replace with your repo URL)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Push
git push -u origin main
```

## 🚀 Step 2: Run the Flutter App

### Prerequisites Check

1. **Verify Flutter Installation:**
   ```bash
   flutter doctor
   ```
   This will show what's installed and what's missing.

2. **Install Flutter (if not installed):**
   - Download from: https://flutter.dev/docs/get-started/install
   - Or use Homebrew on macOS:
     ```bash
     brew install --cask flutter
     ```

### Install Dependencies

```bash
cd /Users/lavish/KidsApp

# Get Flutter packages
flutter pub get

# Generate code (for Riverpod generators)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run on Different Platforms

#### Option 1: Run on iOS Simulator (macOS only)

```bash
# Open iOS Simulator
open -a Simulator

# Run the app
flutter run
```

#### Option 2: Run on Android Emulator

```bash
# List available emulators
flutter emulators

# Launch an emulator (replace with your emulator name)
flutter emulators --launch <emulator_id>

# Or start Android Studio and launch emulator from there

# Run the app
flutter run
```

#### Option 3: Run on Physical Device

**For Android:**
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Run: `flutter devices` to see connected devices
5. Run: `flutter run`

**For iOS:**
1. Connect iPhone/iPad via USB
2. Trust the computer on your device
3. Run: `flutter devices`
4. Run: `flutter run`

#### Option 4: Run in Chrome (Web - Limited Support)

```bash
flutter run -d chrome
```

**Note:** Some features (like text-to-speech) may not work perfectly on web.

### Common Commands

```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run in release mode (optimized)
flutter run --release

# Build APK (Android)
flutter build apk

# Build iOS app
flutter build ios

# Clean build
flutter clean
flutter pub get
```

## 🐛 Troubleshooting

### Issue: "flutter: command not found"
**Solution:**
```bash
# Add Flutter to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:/path/to/flutter/bin"

# Then reload shell
source ~/.zshrc  # or source ~/.bash_profile
```

### Issue: "No devices found"
**Solutions:**
- For Android: Make sure USB debugging is enabled
- For iOS: Make sure device is trusted and developer mode is enabled
- Check: `flutter doctor` for setup issues

### Issue: "Dependencies not installing"
**Solution:**
```bash
flutter clean
rm pubspec.lock
flutter pub get
```

### Issue: "Build errors"
**Solution:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Issue: "Text-to-speech not working"
**Note:** TTS requires a physical device or emulator with proper permissions. Some emulators don't support TTS.

## 📱 Testing Checklist

After running the app:

- [ ] Onboarding screen appears
- [ ] Age selection works
- [ ] Home screen loads with learning modules
- [ ] Can navigate to different modules
- [ ] Text-to-speech works (on physical device)
- [ ] Break reminder appears after 30 minutes
- [ ] Settings screen accessible
- [ ] Parent controls require PIN
- [ ] Dark mode toggle works
- [ ] Font size adjustment works

## 🔄 Updating GitHub

After making changes:

```bash
# Check what changed
git status

# Add changes
git add .

# Commit
git commit -m "Description of changes"

# Push to GitHub
git push
```

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GitHub Guides](https://guides.github.com/)
- [Flutter Setup Guide](https://flutter.dev/docs/get-started/install)
