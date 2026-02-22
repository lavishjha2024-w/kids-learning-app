import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

/// Stories screen with narration
class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.spacingXLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book,
                  size: 100,
                  color: AppColors.lavender,
                ),
                SizedBox(height: AppConstants.spacingLarge),
                Text(
                  'Stories Coming Soon!',
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppConstants.spacingMedium),
                Text(
                  'We\'re preparing wonderful stories for you!',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
