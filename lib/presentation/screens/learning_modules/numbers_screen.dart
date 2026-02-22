import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/kid_friendly_button.dart';

/// Numbers learning screen with counting
class NumbersScreen extends ConsumerStatefulWidget {
  const NumbersScreen({super.key});

  @override
  ConsumerState<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends ConsumerState<NumbersScreen> {
  final FlutterTts _tts = FlutterTts();
  int _currentNumber = 1;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(0.8);
  }

  Future<void> _speakNumber(int number) async {
    await _tts.speak(number.toString());
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Widget _buildVisualCount(int count) {
    return Wrap(
      spacing: AppConstants.spacingSmall,
      runSpacing: AppConstants.spacingSmall,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.mintGreen,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Numbers'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Large number display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Large number
                    GestureDetector(
                      onTap: () => _speakNumber(_currentNumber),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.mintGreen.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_currentNumber',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.spacingLarge),
                    
                    // Visual count
                    _buildVisualCount(_currentNumber),
                    SizedBox(height: AppConstants.spacingLarge),
                    
                    // Speak button
                    KidFriendlyButton(
                      label: 'Listen',
                      icon: Icons.volume_up,
                      onPressed: () => _speakNumber(_currentNumber),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation
            Container(
              padding: EdgeInsets.all(AppConstants.spacingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KidFriendlyButton(
                    label: 'Previous',
                    icon: Icons.arrow_back,
                    onPressed: _currentNumber > 1
                        ? () {
                            setState(() {
                              _currentNumber--;
                            });
                            _speakNumber(_currentNumber);
                          }
                        : null,
                  ),
                  KidFriendlyButton(
                    label: 'Next',
                    icon: Icons.arrow_forward,
                    onPressed: _currentNumber < 10
                        ? () {
                            setState(() {
                              _currentNumber++;
                            });
                            _speakNumber(_currentNumber);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
