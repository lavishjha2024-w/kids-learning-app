import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/kid_friendly_button.dart';
import '../providers/settings_provider.dart';
import '../../main.dart';

/// Onboarding screen for age selection and initial setup
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int? _selectedAge;
  int _currentStep = 0;

  final List<String> _welcomeMessages = [
    'Welcome to Kids Learning! 👋',
    'Let\'s get started!',
    'How old are you?',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome icon/animation
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school,
                  size: 80,
                  color: AppColors.primaryAccent,
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXLarge),
              
              // Welcome message
              Text(
                _welcomeMessages[_currentStep],
                style: theme.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.spacingXLarge),
              
              // Age selection
              if (_currentStep == 2) ...[
                Text(
                  'Select your age',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                
                // Age buttons
                Wrap(
                  spacing: AppConstants.spacingMedium,
                  runSpacing: AppConstants.spacingMedium,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    AppConstants.maxAge - AppConstants.minAge + 1,
                    (index) {
                      final age = AppConstants.minAge + index;
                      final isSelected = _selectedAge == age;
                      
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAge = age;
                          });
                        },
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryAccent
                                : AppColors.lightBlue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.primaryAccent,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '$age',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              
              const SizedBox(height: AppConstants.spacingXLarge),
              
              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_currentStep > 0)
                    KidFriendlyButton(
                      label: 'Back',
                      icon: Icons.arrow_back,
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                    ),
                  KidFriendlyButton(
                    label: _currentStep < 2 ? 'Next' : 'Start Learning!',
                    icon: _currentStep < 2 ? Icons.arrow_forward : Icons.play_arrow,
                    onPressed: _currentStep < 2
                        ? () {
                            setState(() {
                              _currentStep++;
                            });
                          }
                        : (_selectedAge != null
                            ? () {
                                ref
                                    .read(settingsProvider.notifier)
                                    .setUserAge(_selectedAge!);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => const MainScreenWrapper(),
                                  ),
                                );
                              }
                            : null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
