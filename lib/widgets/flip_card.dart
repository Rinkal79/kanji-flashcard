import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/kanji_card.dart';
import '../theme/app_theme.dart';

class FlipCardWidget extends StatefulWidget {
  final KanjiCard card;
  final VoidCallback? onTap;

  const FlipCardWidget({
    super.key,
    required this.card,
    this.onTap,
  });

  @override
  State<FlipCardWidget> createState() => FlipCardWidgetState();
}

class FlipCardWidgetState extends State<FlipCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(FlipCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset to front when card changes
    if (oldWidget.card.id != widget.card.id) {
      _controller.reset();
      _isFront = true;
    }
  }

  void flip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _isFront = !_isFront);
    widget.onTap?.call();
  }

  bool get isShowingFront => _isFront;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * math.pi;
          final isShowingFrontFace = angle <= math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isShowingFrontFace
                ? _buildFront(context)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBack(context),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFront(BuildContext context) {
    return _CardShell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.card.jlptLevel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.accentIndigo,
                  letterSpacing: 3,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.card.kanji,
            style: const TextStyle(
              fontSize: 120,
              color: AppTheme.inkBlack,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app_rounded,
                  size: 16, color: AppTheme.inkGray),
              const SizedBox(width: 6),
              Text(
                'Tap to reveal',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.inkGray,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return _CardShell(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Small kanji reminder
            Text(
              widget.card.kanji,
              style: const TextStyle(
                fontSize: 48,
                color: AppTheme.inkBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            // Meaning
            Text(
              widget.card.meaning,
              style: tt.headlineMedium?.copyWith(
                color: AppTheme.inkBlack,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _Divider(),
            const SizedBox(height: 20),
            // Readings row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ReadingBlock(
                  label: 'ON\'YOMI',
                  value: widget.card.onyomi,
                  accentColor: AppTheme.vermillion,
                ),
                _VerticalDivider(),
                _ReadingBlock(
                  label: 'KUN\'YOMI',
                  value: widget.card.kunyomi,
                  accentColor: AppTheme.accentIndigo,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Divider(),
            const SizedBox(height: 20),
            // Example
            _ExampleBlock(card: widget.card),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 460),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        color: AppTheme.paperWarm,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppTheme.accentIndigo.withOpacity(0.15),
            blurRadius: 64,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ReadingBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;

  const _ReadingBlock({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    letterSpacing: 1.2,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.inkBlack,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ExampleBlock extends StatelessWidget {
  final KanjiCard card;
  const _ExampleBlock({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.paperDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXAMPLE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.inkGray,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                card.exampleWord,
                style: const TextStyle(
                  fontSize: 22,
                  color: AppTheme.inkBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                card.exampleReading,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.inkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            card.exampleMeaning,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.inkGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppTheme.inkGray.withOpacity(0.2),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 60,
      color: AppTheme.inkGray.withOpacity(0.2),
    );
  }
}
