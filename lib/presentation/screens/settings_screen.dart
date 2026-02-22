import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../providers/settings_provider.dart';
import 'parent_control_screen.dart';

/// Settings screen with accessibility options
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          children: [
            // Appearance
            _SectionHeader(title: 'Appearance'),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Soft dark theme'),
              value: settings.darkModeEnabled,
              onChanged: (value) => settingsNotifier.toggleDarkMode(),
            ),
            SwitchListTile(
              title: const Text('Calm Mode'),
              subtitle: const Text('Reduce animations and sounds'),
              value: settings.calmModeEnabled,
              onChanged: (value) => settingsNotifier.toggleCalmMode(),
            ),

            const Divider(height: AppConstants.spacingXLarge),

            // Accessibility
            _SectionHeader(title: 'Accessibility'),
            ListTile(
              title: const Text('Font Size'),
              subtitle: Text('${(settings.fontSizeMultiplier * 100).toInt()}%'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (settings.fontSizeMultiplier > 0.8) {
                        settingsNotifier.setFontSizeMultiplier(
                          settings.fontSizeMultiplier - 0.1,
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (settings.fontSizeMultiplier < 1.5) {
                        settingsNotifier.setFontSizeMultiplier(
                          settings.fontSizeMultiplier + 0.1,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SwitchListTile(
              title: const Text('Colorblind Mode'),
              subtitle: const Text('Colorblind-friendly colors'),
              value: settings.colorblindModeEnabled,
              onChanged: (value) => settingsNotifier.toggleColorblindMode(),
            ),
            SwitchListTile(
              title: const Text('Dyslexia Font'),
              subtitle: const Text('Easier to read font'),
              value: settings.dyslexiaFontEnabled,
              onChanged: (value) => settingsNotifier.toggleDyslexiaFont(),
            ),

            const Divider(height: AppConstants.spacingXLarge),

            // Audio
            _SectionHeader(title: 'Audio'),
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: settings.soundEnabled,
              onChanged: (value) => settingsNotifier.toggleSound(),
            ),
            SwitchListTile(
              title: const Text('Background Music'),
              value: settings.musicEnabled,
              onChanged: (value) => settingsNotifier.toggleMusic(),
            ),
            ListTile(
              title: const Text('Volume'),
              subtitle: Slider(
                value: settings.soundVolume,
                onChanged: (value) => settingsNotifier.setSoundVolume(value),
                min: 0.0,
                max: 1.0,
                divisions: 10,
              ),
            ),

            const Divider(height: AppConstants.spacingXLarge),

            // Parent Controls
            _SectionHeader(title: 'Parent Controls'),
            ListTile(
              title: const Text('Parent Panel'),
              subtitle: const Text('Manage usage limits and settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentControlScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.spacingMedium,
        bottom: AppConstants.spacingSmall,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryAccent,
        ),
      ),
    );
  }
}
