import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../widgets/kid_friendly_button.dart';

/// Alphabets learning screen with voice guidance
class AlphabetsScreen extends ConsumerStatefulWidget {
  const AlphabetsScreen({super.key});

  @override
  ConsumerState<AlphabetsScreen> createState() => _AlphabetsScreenState();
}

class _AlphabetsScreenState extends ConsumerState<AlphabetsScreen> {
  final FlutterTts _tts = FlutterTts();
  String _currentLetter = 'A';
  final List<String> _letters = List.generate(
    26,
    (index) => String.fromCharCode(65 + index),
  );

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5); // Slower for kids
    await _tts.setVolume(0.8);
  }

  Future<void> _speakLetter(String letter) async {
    await _tts.speak(letter);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = _letters.indexOf(_currentLetter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabets'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Large letter display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Large letter
                    GestureDetector(
                      onTap: () => _speakLetter(_currentLetter),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _currentLetter,
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppConstants.spacingLarge),
                    
                    // Speak button
                    KidFriendlyButton(
                      label: 'Listen',
                      icon: Icons.volume_up,
                      onPressed: () => _speakLetter(_currentLetter),
                    ),
                  ],
                ),
              ),
            ),

            // Letter grid
            Container(
              padding: EdgeInsets.all(AppConstants.spacingMedium),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KidFriendlyButton(
                        label: 'Previous',
                        icon: Icons.arrow_back,
                        onPressed: currentIndex > 0
                            ? () {
                                setState(() {
                                  _currentLetter = _letters[currentIndex - 1];
                                });
                                _speakLetter(_currentLetter);
                              }
                            : null,
                        isLarge: false,
                      ),
                      KidFriendlyButton(
                        label: 'Next',
                        icon: Icons.arrow_forward,
                        onPressed: currentIndex < _letters.length - 1
                            ? () {
                                setState(() {
                                  _currentLetter = _letters[currentIndex + 1];
                                });
                                _speakLetter(_currentLetter);
                              }
                            : null,
                        isLarge: false,
                      ),
                    ],
                  ),
                  SizedBox(height: AppConstants.spacingMedium),
                  
                  // Letter grid
                  Wrap(
                    spacing: AppConstants.spacingSmall,
                    runSpacing: AppConstants.spacingSmall,
                    alignment: WrapAlignment.center,
                    children: _letters.map((letter) {
                      final isSelected = letter == _currentLetter;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _currentLetter = letter;
                          });
                          _speakLetter(letter);
                        },
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusSmall,
                        ),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryAccent
                                : AppColors.lightBlue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall,
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
                              letter,
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
                    }).toList(),
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
