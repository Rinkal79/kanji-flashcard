import 'package:flutter/material.dart';
import '../models/kanji_card.dart';
import '../services/kanji_service.dart';
import '../theme/app_theme.dart';
import 'flashcard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = KanjiService.instance;

  void _onLevelTap(String level) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FlashcardScreen(level: level),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _onReset(String level) {
    setState(() => _service.resetLevel(level));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$level progress reset'),
        backgroundColor: AppTheme.deepIndigo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final level = _service.availableLevels[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _LevelCard(
                      level: level,
                      progress: _service.getProgressForLevel(level),
                      totalCards: _service.getCardsForLevel(level).length,
                      onTap: () => _onLevelTap(level),
                      onReset: () => _onReset(level),
                    ),
                  );
                },
                childCount: _service.availableLevels.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppTheme.inkBlack,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '漢字',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.vermillion,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            Text(
              'Kanji Cards',
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                    fontSize: 22,
                  ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppTheme.accentIndigo, AppTheme.inkBlack],
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24, top: 60),
              child: Text(
                '字',
                style: TextStyle(
                  fontSize: 120,
                  color: Colors.white.withOpacity(0.06),
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Level Card ───────────────────────────────────────────────────────────────

class _LevelCard extends StatelessWidget {
  final String level;
  final Map<CardStatus, int> progress;
  final int totalCards;
  final VoidCallback onTap;
  final VoidCallback onReset;

  const _LevelCard({
    required this.level,
    required this.progress,
    required this.totalCards,
    required this.onTap,
    required this.onReset,
  });

  static const Map<String, String> _levelDescriptions = {
    'N5': 'Beginner — Basic characters',
    'N4': 'Elementary — Everyday kanji',
    'N3': 'Intermediate — Newspaper kanji',
  };

  static const Map<String, Color> _levelColors = {
    'N5': Color(0xFF10B981), // emerald
    'N4': Color(0xFF3B82F6), // blue
    'N3': Color(0xFFE94560), // vermillion
  };

  @override
  Widget build(BuildContext context) {
    final mastered = progress[CardStatus.mastered] ?? 0;
    final reviewLater = progress[CardStatus.reviewLater] ?? 0;
    final accentColor = _levelColors[level] ?? AppTheme.accentIndigo;
    final masteredFraction = totalCards > 0 ? mastered / totalCards : 0.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.deepIndigo,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accentColor.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Level badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      level,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Card count
                  Text(
                    '$totalCards cards',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.inkGray,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Reset button
                  GestureDetector(
                    onTap: onReset,
                    child: const Icon(Icons.refresh_rounded,
                        size: 18, color: AppTheme.inkGray),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _levelDescriptions[level] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.inkGray,
                ),
              ),
              const SizedBox(height: 20),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: masteredFraction,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor: AlwaysStoppedAnimation(accentColor),
                ),
              ),
              const SizedBox(height: 12),
              // Stat chips
              Row(
                children: [
                  _StatChip(
                    icon: Icons.check_circle_outline_rounded,
                    label: '$mastered mastered',
                    color: AppTheme.masteredGreen,
                  ),
                  const SizedBox(width: 10),
                  _StatChip(
                    icon: Icons.bookmark_border_rounded,
                    label: '$reviewLater to review',
                    color: AppTheme.reviewAmber,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Start button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.play_arrow_rounded, size: 18),
                  label: const Text('Start Review'),
                  style: FilledButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
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

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color),
        ),
      ],
    );
  }
}
