import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/providers/settings_provider.dart';
import '../../core/utils/break_reminder_service.dart';

/// Break reminder dialog following mental health principles
/// Shows friendly, non-intrusive break reminder with breathing animation
class BreakReminderDialog extends ConsumerStatefulWidget {
  final VoidCallback onBreakComplete;
  final VoidCallback? onParentOverride;

  const BreakReminderDialog({
    super.key,
    required this.onBreakComplete,
    this.onParentOverride,
  });

  @override
  ConsumerState<BreakReminderDialog> createState() =>
      _BreakReminderDialogState();
}

class _BreakReminderDialogState extends ConsumerState<BreakReminderDialog>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _countdownController;
  late Timer _countdownTimer;
  int _remainingSeconds = AppConstants.defaultBreakDurationMinutes * 60;
  bool _isBreathing = false;

  @override
  void initState() {
    super.initState();
    
    final settings = ref.read(settingsProvider);
    _remainingSeconds = settings.breakDurationMinutes * 60;

    // Breathing animation
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Countdown timer
    _countdownController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingSeconds),
    );

    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            _countdownController.value =
                1 - (_remainingSeconds / (AppConstants.defaultBreakDurationMinutes * 60));
          } else {
            timer.cancel();
            widget.onBreakComplete();
            Navigator.of(context).pop();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _toggleBreathing() {
    setState(() {
      _isBreathing = !_isBreathing;
      if (_isBreathing) {
        _breathingController.repeat(reverse: true);
      } else {
        _breathingController.stop();
        _breathingController.reset();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _countdownController.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WillPopScope(
      onWillPop: () async {
        // Prevent dismissing during break (unless parent override)
        return false;
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingXLarge),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusXLarge),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Friendly message
              Text(
                "Let's take a short eye break! 🌈",
                style: theme.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                "Stretch and drink water!",
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingXLarge),
              
              // Breathing animation circle
              GestureDetector(
                onTap: _toggleBreathing,
                child: AnimatedBuilder(
                  animation: _breathingController,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.mintGreen.withOpacity(
                          0.3 + (_isBreathing ? _breathingController.value * 0.4 : 0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _isBreathing ? 'Breathe' : 'Tap to\nBreathe',
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXLarge),
              
              // Countdown timer
              Text(
                _formatTime(_remainingSeconds),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: AppColors.primaryAccent,
                ),
              ),
              
              // Progress indicator
              const SizedBox(height: AppConstants.spacingMedium),
              LinearProgressIndicator(
                value: _countdownController.value,
                backgroundColor: AppColors.lightBlue.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                minHeight: 8,
              ),
              
              const SizedBox(height: AppConstants.spacingLarge),
              
              // Parent override button (if available)
              if (widget.onParentOverride != null)
                TextButton(
                  onPressed: () {
                    widget.onParentOverride?.call();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Parent Override',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
