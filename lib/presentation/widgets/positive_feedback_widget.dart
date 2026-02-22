import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// Positive reinforcement widget following mental health principles
/// Avoids addictive patterns, focuses on effort over achievement
class PositiveFeedbackWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const PositiveFeedbackWidget({
    super.key,
    required this.message,
    this.icon = Icons.star,
    this.color = AppColors.successGreen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: AppConstants.spacingSmall),
          Flexible(
            child: Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Predefined positive messages (effort-based, not competitive)
class PositiveMessages {
  static const List<String> effortMessages = [
    'Great effort! 🌟',
    'You tried your best! 💪',
    'Wonderful work! ✨',
    'You\'re doing amazing! 🎉',
    'Keep it up! 🌈',
    'Fantastic! 🌟',
    'You\'re learning so much! 📚',
    'Awesome job! 🎊',
  ];

  static String getRandomMessage() {
    return effortMessages[
        DateTime.now().millisecond % effortMessages.length];
  }
}
