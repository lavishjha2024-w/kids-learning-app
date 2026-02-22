import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/kid_friendly_button.dart';

/// Shapes learning screen
class ShapesScreen extends ConsumerStatefulWidget {
  const ShapesScreen({super.key});

  @override
  ConsumerState<ShapesScreen> createState() => _ShapesScreenState();
}

class _ShapesScreenState extends ConsumerState<ShapesScreen> {
  final FlutterTts _tts = FlutterTts();
  int _currentShapeIndex = 0;

  final List<ShapeData> _shapes = [
    ShapeData(name: 'Circle', color: AppColors.lightBlue, icon: Icons.circle),
    ShapeData(name: 'Square', color: AppColors.mintGreen, icon: Icons.crop_square),
    ShapeData(name: 'Triangle', color: AppColors.lavender, icon: Icons.change_history),
    ShapeData(name: 'Rectangle', color: AppColors.peach, icon: Icons.rectangle_outlined),
    ShapeData(name: 'Star', color: AppColors.primaryAccent, icon: Icons.star),
    ShapeData(name: 'Heart', color: AppColors.avoidRed, icon: Icons.favorite),
  ];

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

  Future<void> _speakShape(String name) async {
    await _tts.speak('This is a $name');
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentShape = _shapes[_currentShapeIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shapes'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Large shape display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Large shape
                    GestureDetector(
                      onTap: () => _speakShape(currentShape.name),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: currentShape.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            currentShape.icon,
                            size: 120,
                            color: currentShape.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),
                    
                    // Shape name
                    Text(
                      currentShape.name,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: currentShape.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),
                    
                    // Speak button
                    KidFriendlyButton(
                      label: 'Listen',
                      icon: Icons.volume_up,
                      onPressed: () => _speakShape(currentShape.name),
                    ),
                  ],
                ),
              ),
            ),

            // Shape grid
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Column(
                children: [
                  // Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KidFriendlyButton(
                        label: 'Previous',
                        icon: Icons.arrow_back,
                        onPressed: _currentShapeIndex > 0
                            ? () {
                                setState(() {
                                  _currentShapeIndex--;
                                });
                                _speakShape(_shapes[_currentShapeIndex].name);
                              }
                            : null,
                      ),
                      KidFriendlyButton(
                        label: 'Next',
                        icon: Icons.arrow_forward,
                        onPressed: _currentShapeIndex < _shapes.length - 1
                            ? () {
                                setState(() {
                                  _currentShapeIndex++;
                                });
                                _speakShape(_shapes[_currentShapeIndex].name);
                              }
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  
                  // Shape grid
                  Wrap(
                    spacing: AppConstants.spacingMedium,
                    runSpacing: AppConstants.spacingMedium,
                    alignment: WrapAlignment.center,
                    children: List.generate(_shapes.length, (index) {
                      final shape = _shapes[index];
                      final isSelected = index == _currentShapeIndex;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _currentShapeIndex = index;
                          });
                          _speakShape(shape.name);
                        },
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: shape.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                            border: isSelected
                                ? Border.all(
                                    color: shape.color,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: Icon(
                            shape.icon,
                            size: 40,
                            color: shape.color,
                          ),
                        ),
                      );
                    }),
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

class ShapeData {
  final String name;
  final Color color;
  final IconData icon;

  ShapeData({
    required this.name,
    required this.color,
    required this.icon,
  });
}
