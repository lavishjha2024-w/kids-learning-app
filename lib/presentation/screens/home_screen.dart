import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/kid_friendly_button.dart';
import '../widgets/learning_card.dart';
import 'learning_modules/alphabets_screen.dart';
import 'learning_modules/numbers_screen.dart';
import 'learning_modules/math_screen.dart';
import 'learning_modules/shapes_screen.dart';
import 'learning_modules/puzzles_screen.dart';
import 'learning_modules/memory_screen.dart';
import 'learning_modules/stories_screen.dart';

/// Home screen following HCI principles:
/// - Clear visual hierarchy
/// - Recognition over recall
/// - Minimal cognitive load
/// - Immediate visual feedback
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome! 👋',
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      'What would you like to learn today?',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              // Learning modules grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppConstants.spacingMedium,
                mainAxisSpacing: AppConstants.spacingMedium,
                childAspectRatio: 0.85,
                children: [
                  LearningCard(
                    title: 'Alphabets',
                    description: 'Learn A to Z',
                    icon: Icons.abc_rounded,
                    cardColor: AppColors.lightBlue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AlphabetsScreen(),
                        ),
                      );
                    },
                  ),
                  LearningCard(
                    title: 'Numbers',
                    description: 'Count 1 to 10',
                    icon: Icons.numbers_rounded,
                    cardColor: AppColors.mintGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NumbersScreen(),
                        ),
                      );
                    },
                  ),
                  LearningCard(
                    title: 'Math',
                    description: 'Add & Subtract',
                    icon: Icons.calculate_rounded,
                    cardColor: AppColors.lavender,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MathScreen(),
                        ),
                      );
                    },
                  ),
                  LearningCard(
                    title: 'Shapes',
                    description: 'Learn shapes',
                    icon: Icons.shapes_rounded,
                    cardColor: AppColors.peach,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShapesScreen(),
                        ),
                      );
                    },
                  ),
                  LearningCard(
                    title: 'Puzzles',
                    description: 'Solve puzzles',
                    icon: Icons.extension_rounded,
                    cardColor: AppColors.lightBlue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PuzzlesScreen(),
                        ),
                      );
                    },
                  ),
                  LearningCard(
                    title: 'Memory',
                    description: 'Match cards',
                    icon: Icons.memory_rounded,
                    cardColor: AppColors.mintGreen,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MemoryScreen(),
                        ),
                      );
                    },
                  ),
                  LearningCard(
                    title: 'Stories',
                    description: 'Listen & read',
                    icon: Icons.menu_book_rounded,
                    cardColor: AppColors.lavender,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StoriesScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
