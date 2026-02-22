import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/kid_friendly_button.dart';

/// Basic math learning screen (addition & subtraction)
class MathScreen extends ConsumerStatefulWidget {
  const MathScreen({super.key});

  @override
  ConsumerState<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends ConsumerState<MathScreen> {
  int _num1 = 2;
  int _num2 = 3;
  String _operator = '+';
  int? _userAnswer;
  bool _showFeedback = false;
  bool _isCorrect = false;

  void _generateNewProblem() {
    final random = Random();
    _num1 = random.nextInt(10) + 1;
    _num2 = random.nextInt(10) + 1;
    
    // Randomly choose addition or subtraction
    if (random.nextBool()) {
      _operator = '+';
    } else {
      _operator = '-';
      // Ensure result is positive
      if (_num1 < _num2) {
        final temp = _num1;
        _num1 = _num2;
        _num2 = temp;
      }
    }
    
    setState(() {
      _userAnswer = null;
      _showFeedback = false;
    });
  }

  int get _correctAnswer {
    if (_operator == '+') {
      return _num1 + _num2;
    } else {
      return _num1 - _num2;
    }
  }

  void _checkAnswer() {
    if (_userAnswer == null) return;
    
    setState(() {
      _isCorrect = _userAnswer == _correctAnswer;
      _showFeedback = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Math'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spacingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Problem display
              Card(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.spacingXLarge),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_num1',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 64,
                            ),
                          ),
                          SizedBox(width: AppConstants.spacingLarge),
                          Text(
                            _operator,
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 64,
                            ),
                          ),
                          SizedBox(width: AppConstants.spacingLarge),
                          Text(
                            '$_num2',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 64,
                            ),
                          ),
                          SizedBox(width: AppConstants.spacingLarge),
                          Text(
                            '=',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 64,
                            ),
                          ),
                          SizedBox(width: AppConstants.spacingLarge),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryAccent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _userAnswer?.toString() ?? '?',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 48,
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppConstants.spacingXLarge),

              // Number pad
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: AppConstants.spacingMedium,
                crossAxisSpacing: AppConstants.spacingMedium,
                childAspectRatio: 1.2,
                children: List.generate(9, (index) {
                  final number = index + 1;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _userAnswer = number;
                        _showFeedback = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.lavender.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                        border: _userAnswer == number
                            ? Border.all(
                                color: AppColors.primaryAccent,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: theme.textTheme.displaySmall,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              SizedBox(height: AppConstants.spacingLarge),

              // Feedback
              if (_showFeedback)
                Container(
                  padding: EdgeInsets.all(AppConstants.spacingMedium),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? AppColors.successGreen.withOpacity(0.2)
                        : AppColors.peach.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isCorrect ? Icons.check_circle : Icons.cancel,
                        color: _isCorrect
                            ? AppColors.successGreen
                            : AppColors.avoidRed,
                        size: 32,
                      ),
                      SizedBox(width: AppConstants.spacingSmall),
                      Text(
                        _isCorrect
                            ? 'Great job! 🌟'
                            : 'Try again! The answer is $_correctAnswer',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: AppConstants.spacingLarge),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KidFriendlyButton(
                    label: 'Check',
                    icon: Icons.check,
                    onPressed: _userAnswer != null ? _checkAnswer : null,
                  ),
                  KidFriendlyButton(
                    label: 'New',
                    icon: Icons.refresh,
                    onPressed: _generateNewProblem,
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
