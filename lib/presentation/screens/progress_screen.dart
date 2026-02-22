import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../providers/usage_tracker_provider.dart';
import 'package:intl/intl.dart';

/// Progress screen showing learning achievements (effort-based, not competitive)
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final todayUsage = ref.watch(usageTrackerProvider.notifier).getTodayUsage();
    final weeklyUsage = ref.watch(usageTrackerProvider.notifier).getWeeklyUsage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Learning",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppConstants.spacingMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.access_time,
                            label: 'Time',
                            value: '${todayUsage?.totalUsageTime.inMinutes ?? 0} min',
                            color: AppColors.primaryAccent,
                          ),
                          _StatItem(
                            icon: Icons.school,
                            label: 'Sessions',
                            value: '${todayUsage?.sessionCount ?? 0}',
                            color: AppColors.mintGreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingLarge),

              // Positive reinforcement message
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.successGreen,
                      size: 32,
                    ),
                    const SizedBox(width: AppConstants.spacingMedium),
                    Expanded(
                      child: Text(
                        "Great effort! You're doing amazing! 🌟",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingLarge),

              // Weekly summary
              Text(
                'This Week',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              ...weeklyUsage.map((usage) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        DateFormat('EEEE, MMM d').format(usage.date),
                        style: theme.textTheme.bodyLarge,
                      ),
                      trailing: Text(
                        '${usage.totalUsageTime.inMinutes} min',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
