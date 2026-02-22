# Install Flutter on macOS

Flutter was not found. Follow **one** of the methods below.

---

## Method 1: Install with Homebrew (easiest)

If you have [Homebrew](https://brew.sh/) installed:

```bash
# Install Flutter
brew install --cask flutter

# Add to PATH (usually automatic, but if needed add to ~/.zshrc):
# export PATH="$PATH:/opt/homebrew/Caskroom/flutter/*/flutter/bin"

# Restart terminal, then verify:
flutter doctor
```

---

## Method 2: Manual install (no Homebrew)

1. **Download Flutter SDK**
   - Go to: https://docs.flutter.dev/get-started/install/macos
   - Or direct download: https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_*.zip (Apple Silicon)  
     or: https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_*.zip (Intel)

2. **Extract**
   ```bash
   cd ~
   unzip ~/Downloads/flutter_macos_*.zip
   ```

3. **Add to PATH**
   ```bash
   # Open your shell config
   nano ~/.zshrc

   # Add this line (change path if you put Flutter somewhere else):
   export PATH="$PATH:$HOME/flutter/bin"

   # Save (Ctrl+O, Enter, Ctrl+X), then:
   source ~/.zshrc
   ```

4. **Verify**
   ```bash
   flutter doctor
   ```

---

## Method 3: Using fvm (Flutter Version Management)

```bash
brew tap leoafarias/fvm
brew install fvm
fvm install stable
fvm use stable
export PATH="$PATH:$HOME/fvm/default/bin"
```

---

## After installing

1. **Run doctor**
   ```bash
   flutter doctor
   ```

2. **Fix any issues** (e.g. accept Android licenses):
   ```bash
   flutter doctor --android-licenses
   ```

3. **Run your app**
   ```bash
   cd /Users/lavish/KidsApp
   flutter pub get
   flutter run
   ```

---

## If you use Bash instead of Zsh

Use `~/.bash_profile` or `~/.bashrc` instead of `~/.zshrc` when adding the PATH.
