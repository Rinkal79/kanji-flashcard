import 'package:flutter/material.dart';
import '../models/kanji_card.dart';
import '../services/kanji_service.dart';
import '../theme/app_theme.dart';
import '../widgets/flip_card.dart';

class FlashcardScreen extends StatefulWidget {
  final String level;
  const FlashcardScreen({super.key, required this.level});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with TickerProviderStateMixin {
  late List<KanjiCard> _cards;
  int _currentIndex = 0;
  final _service = KanjiService.instance;
  final GlobalKey<FlipCardWidgetState> _flipKey = GlobalKey();

  // Swipe animation
  late AnimationController _swipeController;
  late Animation<Offset> _swipeOffset;
  late Animation<double> _swipeOpacity;
  _SwipeDirection? _swipeDirection;

  // Drag state
  double _dragX = 0;
  static const double _swipeThreshold = 100;

  @override
  void initState() {
    super.initState();
    _cards = _service.getCardsForLevel(widget.level);
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _swipeOffset =
        Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(
      CurvedAnimation(parent: _swipeController, curve: Curves.easeInCubic),
    );
    _swipeOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _swipeController, curve: Curves.easeInCubic),
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  bool get _isDone => _currentIndex >= _cards.length;
  KanjiCard? get _currentCard =>
      _isDone ? null : _cards[_currentIndex];

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() => _dragX += details.delta.dx);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragX > _swipeThreshold) {
      _swipeCard(CardStatus.mastered);
    } else if (_dragX < -_swipeThreshold) {
      _swipeCard(CardStatus.reviewLater);
    } else {
      // Spring back
      setState(() => _dragX = 0);
    }
  }

  void _swipeCard(CardStatus status, {bool animated = true}) {
    final card = _currentCard;
    if (card == null) return;

    _service.updateCardStatus(card.id, status);

    final direction =
        status == CardStatus.mastered ? _SwipeDirection.right : _SwipeDirection.left;

    setState(() {
      _swipeDirection = direction;
      _swipeOffset = Tween<Offset>(
        begin: Offset(_dragX, 0),
        end: Offset(direction == _SwipeDirection.right ? 600 : -600, 0),
      ).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInCubic));
    });

    _swipeController.forward(from: 0).then((_) {
      setState(() {
        _currentIndex++;
        _dragX = 0;
        _swipeDirection = null;
      });
      _swipeController.reset();
    });
  }

  Color get _overlayColor {
    if (_dragX > 40) return AppTheme.masteredGreen.withOpacity((_dragX - 40) / 200);
    if (_dragX < -40)
      return AppTheme.vermillion.withOpacity((-_dragX - 40) / 200);
    return Colors.transparent;
  }

  String get _overlayLabel {
    if (_dragX > _swipeThreshold * 0.6) return 'Mastered!';
    if (_dragX < -_swipeThreshold * 0.6) return 'Review Later';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!_isDone)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1} / ${_cards.length}',
                  style: const TextStyle(
                    color: AppTheme.inkGray,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: _cards.isEmpty ? 0 : _currentIndex / _cards.length,
            minHeight: 3,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor:
                const AlwaysStoppedAnimation(AppTheme.accentIndigo),
          ),
          Expanded(
            child: _isDone ? _buildDoneState() : _buildCardState(),
          ),
          if (!_isDone) _buildActionBar(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCardState() {
    final card = _currentCard!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _swipeController,
              builder: (_, __) {
                final offset = _swipeController.isAnimating
                    ? _swipeOffset.value
                    : Offset(_dragX, _dragX.abs() * 0.06);
                final angle = _dragX * 0.0015;

                return Transform.translate(
                  offset: offset,
                  child: Transform.rotate(
                    angle: angle,
                    child: Opacity(
                      opacity:
                          _swipeController.isAnimating ? _swipeOpacity.value : 1,
                      child: GestureDetector(
                        onHorizontalDragUpdate: _onDragUpdate,
                        onHorizontalDragEnd: _onDragEnd,
                        child: Stack(
                          children: [
                            FlipCardWidget(key: _flipKey, card: card),
                            // Swipe overlay
                            if (_overlayColor != Colors.transparent)
                              Positioned.fill(
                                child: AnimatedContainer(
                                  duration: Duration.zero,
                                  decoration: BoxDecoration(
                                    color: _overlayColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _overlayLabel,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 8,
                                            color: Colors.black26,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Hint text
          Text(
            'Swipe right to mark mastered  ·  Swipe left to review later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  color: AppTheme.inkGray.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Review later button
          _ActionButton(
            icon: Icons.bookmark_border_rounded,
            label: 'Review',
            color: AppTheme.reviewAmber,
            onTap: () => _swipeCard(CardStatus.reviewLater),
          ),
          // Flip button
          _ActionButton(
            icon: Icons.flip_rounded,
            label: 'Flip',
            color: AppTheme.accentIndigo,
            onTap: () => _flipKey.currentState?.flip(),
            isPrimary: true,
          ),
          // Mastered button
          _ActionButton(
            icon: Icons.check_circle_outline_rounded,
            label: 'Mastered',
            color: AppTheme.masteredGreen,
            onTap: () => _swipeCard(CardStatus.mastered),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneState() {
    final mastered =
        _cards.where((c) => c.status == CardStatus.mastered).length;
    final review =
        _cards.where((c) => c.status == CardStatus.reviewLater).length;
    final total = _cards.length;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Trophy
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.masteredGreen.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                size: 48,
                color: AppTheme.masteredGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Deck Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ve reviewed all ${widget.level} cards',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SummaryStatCard(
                  label: 'Mastered',
                  value: '$mastered / $total',
                  color: AppTheme.masteredGreen,
                  icon: Icons.check_circle_rounded,
                ),
                const SizedBox(width: 16),
                _SummaryStatCard(
                  label: 'To Review',
                  value: '$review / $total',
                  color: AppTheme.reviewAmber,
                  icon: Icons.bookmark_rounded,
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _cards = _service.getCardsForLevel(widget.level);
                    _currentIndex = 0;
                  });
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Restart'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.accentIndigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.paperWarm,
                  side: BorderSide(color: AppTheme.inkGray.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Back to Levels'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(isPrimary ? 18 : 14),
        decoration: BoxDecoration(
          color: color.withOpacity(isPrimary ? 0.2 : 0.12),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.4),
            width: isPrimary ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: isPrimary ? 28 : 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryStatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.deepIndigo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.inkGray,
            ),
          ),
        ],
      ),
    );
  }
}

enum _SwipeDirection { left, right }
