import 'package:flutter/material.dart';
import '../models/match.dart';
import 'glass_card.dart';
import 'live_score_chip.dart';

class HeroMatchCard extends StatefulWidget {
  final Match match;
  final VoidCallback? onTap;

  const HeroMatchCard({super.key, required this.match, this.onTap});

  @override
  State<HeroMatchCard> createState() => _HeroMatchCardState();
}

class _HeroMatchCardState extends State<HeroMatchCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final m = widget.match;
    final inn = m.activeInnings;

    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        return GlassCard(
          onTap: widget.onTap,
          glowColor: cs.primaryContainer.withValues(alpha: 0.15 + _glow.value * 0.15),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(color: cs.error, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text('LIVE', style: tt.labelSmall!.copyWith(color: cs.error, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(m.formatLabel, style: tt.labelSmall),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(m.homeTeam.flagEmoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 4),
                        Text(m.homeTeam.shortCode, style: tt.titleMedium),
                        if (m.innings1 != null)
                          Text(m.innings1!.scoreString, style: tt.headlineMedium!.copyWith(color: cs.primary)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text('VS', style: tt.labelLarge!.copyWith(color: cs.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      if (inn != null)
                        Text(inn.oversString, style: tt.labelSmall),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(m.awayTeam.flagEmoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 4),
                        Text(m.awayTeam.shortCode, style: tt.titleMedium),
                        if (m.innings2 != null)
                          Text(m.innings2!.scoreString, style: tt.headlineMedium!.copyWith(color: cs.secondary)),
                      ],
                    ),
                  ),
                ],
              ),
              if (inn != null && inn.recentBalls.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: inn.recentBalls
                      .map((b) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: LiveScoreChip(text: b),
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                m.venue,
                style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
