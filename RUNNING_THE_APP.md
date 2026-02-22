# Running the Kids Learning App

## ✅ Dependencies Installed Successfully!

Your `flutter pub get` completed successfully. Now you need to set up a device to run the app.

---

## Option 1: iOS Simulator (Easiest on macOS)

### Step 1: Open iOS Simulator
```bash
# Open Simulator
open -a Simulator
```

### Step 2: Wait for Simulator to Load
- Wait for the iOS Simulator window to appear
- It may take 30-60 seconds on first launch

### Step 3: Run Your App
```bash
cd /Users/lavish/KidsApp
flutter run
```

**Note:** If you get an error about iOS not being configured, run:
```bash
flutter doctor
```
And follow the instructions to set up Xcode/iOS development.

---

## Option 2: Android Emulator

### Step 1: Install Android Studio
- Download from: https://developer.android.com/studio
- Install Android Studio

### Step 2: Set Up Android Emulator
1. Open Android Studio
2. Go to **Tools → Device Manager**
3. Click **Create Device**
4. Select a device (e.g., Pixel 5)
5. Download a system image (e.g., Android 13)
6. Click **Finish**

### Step 3: Start Emulator
- In Android Studio Device Manager, click the ▶️ play button next to your emulator
- OR run: `flutter emulators --launch <emulator_id>`

### Step 4: Run Your App
```bash
cd /Users/lavish/KidsApp
flutter run
```

---

## Option 3: Enable macOS Desktop Support (Quick Test)

If you want to test quickly on macOS desktop:

```bash
cd /Users/lavish/KidsApp

# Enable macOS support
flutter create --platforms=macos .

# Run on macOS
flutter run -d macos
```

**Note:** Some features (like text-to-speech) may not work perfectly on desktop.

---

## Option 4: Enable Web Support (Quick Test)

For quick testing in browser:

```bash
cd /Users/lavish/KidsApp

# Enable web support
flutter create --platforms=web .

# Run in Chrome
flutter run -d chrome
```

**Note:** Text-to-speech and some native features won't work on web.

---

## Option 5: Physical Device

### For iPhone/iPad:
1. Connect device via USB
2. Trust the computer on your device
3. Run: `flutter devices` to see your device
4. Run: `flutter run`

### For Android:
1. Enable Developer Options on your phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter devices`
5. Run: `flutter run`

---

## Recommended: iOS Simulator

Since you're on macOS, **iOS Simulator is the easiest**:

```bash
# 1. Open Simulator
open -a Simulator

# 2. Wait for it to load (30-60 seconds)

# 3. Run your app
cd /Users/lavish/KidsApp
flutter run
```

---

## Troubleshooting

### "No devices found"
- Make sure Simulator/Emulator is running
- Check: `flutter devices`
- For iOS: Make sure Xcode is installed (`xcode-select --install`)

### "iOS not configured"
```bash
flutter doctor
# Follow instructions to install Xcode Command Line Tools
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### "Android licenses not accepted"
```bash
flutter doctor --android-licenses
# Press 'y' to accept all licenses
```

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

---

## Quick Start Commands

```bash
# Check available devices
flutter devices

# Open iOS Simulator
open -a Simulator

# Run app
cd /Users/lavish/KidsApp
flutter run

# Run on specific device
flutter run -d <device_id>
```
