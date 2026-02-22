import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../providers/settings_provider.dart';
import '../providers/usage_tracker_provider.dart';
import 'package:intl/intl.dart';

/// Parent control panel with PIN protection
class ParentControlScreen extends ConsumerStatefulWidget {
  const ParentControlScreen({super.key});

  @override
  ConsumerState<ParentControlScreen> createState() =>
      _ParentControlScreenState();
}

class _ParentControlScreenState extends ConsumerState<ParentControlScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _isAuthenticated = false;
  bool _isEnteringPin = true;

  @override
  void initState() {
    super.initState();
    _checkPinStatus();
  }

  void _checkPinStatus() {
    final settings = ref.read(settingsProvider);
    if (settings.parentPin == null || settings.parentPin!.isEmpty) {
      // No PIN set, allow access
      setState(() {
        _isAuthenticated = true;
        _isEnteringPin = false;
      });
    }
  }

  void _verifyPin() {
    final settings = ref.read(settingsProvider);
    if (_pinController.text == settings.parentPin) {
      setState(() {
        _isAuthenticated = true;
        _isEnteringPin = false;
      });
      _pinController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect PIN. Please try again.'),
          backgroundColor: AppColors.avoidRed,
        ),
      );
      _pinController.clear();
    }
  }

  void _setPin() {
    if (_pinController.text.length >= 4) {
      ref.read(settingsProvider.notifier).setParentPin(_pinController.text);
      setState(() {
        _isAuthenticated = true;
        _isEnteringPin = false;
      });
      _pinController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN set successfully!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN must be at least 4 digits'),
          backgroundColor: AppColors.avoidRed,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEnteringPin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Parent Control'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingXLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 80,
                  color: AppColors.primaryAccent,
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                Text(
                  ref.read(settingsProvider).parentPin == null
                      ? 'Set Parent PIN'
                      : 'Enter Parent PIN',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppConstants.spacingXLarge),
                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                  decoration: const InputDecoration(
                    hintText: 'Enter PIN',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                ElevatedButton(
                  onPressed: ref.read(settingsProvider).parentPin == null
                      ? _setPin
                      : _verifyPin,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 56),
                  ),
                  child: Text(
                    ref.read(settingsProvider).parentPin == null
                        ? 'Set PIN'
                        : 'Verify',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Control Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () {
              setState(() {
                _isAuthenticated = false;
                _isEnteringPin = true;
              });
            },
            tooltip: 'Lock',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          children: [
            _buildUsageAnalytics(),
            const Divider(height: AppConstants.spacingXLarge),
            _buildUsageLimits(),
            const Divider(height: AppConstants.spacingXLarge),
            _buildBreakSettings(),
            const Divider(height: AppConstants.spacingXLarge),
            _buildContentControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageAnalytics() {
    final theme = Theme.of(context);
    final todayUsage = ref.watch(usageTrackerProvider.notifier).getTodayUsage();
    final weeklyUsage = ref.watch(usageTrackerProvider.notifier).getWeeklyUsage();

    final totalWeeklyMinutes = weeklyUsage.fold<int>(
      0,
      (sum, usage) => sum + usage.totalUsageTime.inMinutes,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Analytics',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            child: Column(
              children: [
                _AnalyticsRow(
                  label: 'Today',
                  value: '${todayUsage?.totalUsageTime.inMinutes ?? 0} minutes',
                ),
                const Divider(),
                _AnalyticsRow(
                  label: 'This Week',
                  value: '$totalWeeklyMinutes minutes',
                ),
                const Divider(),
                _AnalyticsRow(
                  label: 'Total Sessions',
                  value: '${todayUsage?.sessionCount ?? 0}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsageLimits() {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Usage Limits',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        SwitchListTile(
          title: const Text('Enable Daily Limit'),
          subtitle: Text(
            settings.dailyUsageLimitMinutes != null
                ? '${settings.dailyUsageLimitMinutes} minutes per day'
                : 'No limit set',
          ),
          value: settings.dailyUsageLimitMinutes != null,
          onChanged: (value) {
            settingsNotifier.setDailyUsageLimit(value ? 60 : null);
          },
        ),
        if (settings.dailyUsageLimitMinutes != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  '${settings.dailyUsageLimitMinutes} minutes',
                  style: theme.textTheme.bodyLarge,
                ),
                Slider(
                  value: (settings.dailyUsageLimitMinutes ?? 60).toDouble(),
                  min: 15,
                  max: 120,
                  divisions: 7,
                  label: '${settings.dailyUsageLimitMinutes} minutes',
                  onChanged: (value) {
                    settingsNotifier.setDailyUsageLimit(value.toInt());
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBreakSettings() {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Break Reminders',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        ListTile(
          title: const Text('Break Interval'),
          subtitle: Text('${settings.breakIntervalMinutes} minutes'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (settings.breakIntervalMinutes > 15) {
                    settingsNotifier.setBreakInterval(
                      settings.breakIntervalMinutes - 5,
                    );
                  }
                },
              ),
              Text('${settings.breakIntervalMinutes}'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (settings.breakIntervalMinutes < 60) {
                    settingsNotifier.setBreakInterval(
                      settings.breakIntervalMinutes + 5,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        ListTile(
          title: const Text('Break Duration'),
          subtitle: Text('${settings.breakDurationMinutes} minutes'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (settings.breakDurationMinutes > 1) {
                    settingsNotifier.setBreakDuration(
                      settings.breakDurationMinutes - 1,
                    );
                  }
                },
              ),
              Text('${settings.breakDurationMinutes}'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (settings.breakDurationMinutes < 10) {
                    settingsNotifier.setBreakDuration(
                      settings.breakDurationMinutes + 1,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentControls() {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Content Controls',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppConstants.spacingMedium),
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
        SwitchListTile(
          title: const Text('Calm Mode'),
          subtitle: const Text('Reduce animations and sounds'),
          value: settings.calmModeEnabled,
          onChanged: (value) => settingsNotifier.toggleCalmMode(),
        ),
      ],
    );
  }
}

class _AnalyticsRow extends StatelessWidget {
  final String label;
  final String value;

  const _AnalyticsRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryAccent,
          ),
        ),
      ],
    );
  }
}
