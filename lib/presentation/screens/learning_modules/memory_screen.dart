import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// Memory matching game
class MemoryScreen extends ConsumerStatefulWidget {
  const MemoryScreen({super.key});

  @override
  ConsumerState<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends ConsumerState<MemoryScreen> {
  late List<int> _cards;
  List<int> _flippedCards = [];
  List<int> _matchedCards = [];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Create pairs of numbers (0-5 = 6 pairs)
    final numbers = List.generate(6, (index) => index);
    _cards = [...numbers, ...numbers];
    _cards.shuffle(Random());
    _flippedCards = [];
    _matchedCards = [];
  }

  void _flipCard(int index) {
    if (_isProcessing ||
        _flippedCards.contains(index) ||
        _matchedCards.contains(index)) {
      return;
    }

    setState(() {
      _flippedCards.add(index);
    });

    if (_flippedCards.length == 2) {
      _isProcessing = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          final firstCard = _cards[_flippedCards[0]];
          final secondCard = _cards[_flippedCards[1]];

          if (firstCard == secondCard) {
            setState(() {
              _matchedCards.addAll(_flippedCards);
              _flippedCards = [];
              _isProcessing = false;
            });

            // Check if game is complete
            if (_matchedCards.length == _cards.length) {
              _showWinDialog();
            }
          } else {
            setState(() {
              _flippedCards = [];
              _isProcessing = false;
            });
          }
        }
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great Job! 🌟'),
        content: const Text('You matched all the cards!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Color _getCardColor(int value) {
    final colors = [
      AppColors.lightBlue,
      AppColors.mintGreen,
      AppColors.lavender,
      AppColors.peach,
      AppColors.primaryAccent,
      AppColors.successGreen,
    ];
    return colors[value % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
            tooltip: 'New Game',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppConstants.spacingMedium,
              mainAxisSpacing: AppConstants.spacingMedium,
              childAspectRatio: 1,
            ),
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final isFlipped = _flippedCards.contains(index);
              final isMatched = _matchedCards.contains(index);
              final cardValue = _cards[index];

              return InkWell(
                onTap: () => _flipCard(index),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                child: Container(
                  decoration: BoxDecoration(
                    color: isFlipped || isMatched
                        ? _getCardColor(cardValue).withOpacity(0.3)
                        : AppColors.lightBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                    border: Border.all(
                      color: isMatched
                          ? _getCardColor(cardValue)
                          : AppColors.primaryAccent,
                      width: isMatched ? 3 : 2,
                    ),
                  ),
                  child: Center(
                    child: isFlipped || isMatched
                        ? Icon(
                            Icons.star,
                            size: 40,
                            color: _getCardColor(cardValue),
                          )
                        : Icon(
                            Icons.help_outline,
                            size: 40,
                            color: AppColors.textSecondary,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
