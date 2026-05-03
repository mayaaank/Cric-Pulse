import 'package:flutter/material.dart';

class XpProgressBar extends StatefulWidget {
  final double progress;
  final String label;
  final int currentXp;
  final int maxXp;

  const XpProgressBar({
    super.key,
    required this.progress,
    required this.label,
    required this.currentXp,
    required this.maxXp,
  });

  @override
  State<XpProgressBar> createState() => _XpProgressBarState();
}

class _XpProgressBarState extends State<XpProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label, style: Theme.of(context).textTheme.labelLarge),
            Text(
              '${widget.currentXp} / ${widget.maxXp} XP',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) {
            return Container(
              height: 12,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: widget.progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    gradient: LinearGradient(
                      colors: [cs.primaryContainer, const Color(0xFF00E5FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primaryContainer.withValues(alpha: 0.3 + _pulse.value * 0.3),
                        blurRadius: 8 + _pulse.value * 4,
                        spreadRadius: _pulse.value * 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
