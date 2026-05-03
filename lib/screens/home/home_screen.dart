import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/live_scores_provider.dart';
import '../../providers/predict_provider.dart';
import '../../providers/trivia_provider.dart';
import '../../widgets/hero_match_card.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/live_ticker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<LiveScoresProvider>(
      builder: (context, prov, _) {
        final live = prov.liveMatches;
        final predict = context.watch<PredictProvider>();
        final trivia = context.watch<TriviaProvider>();
        final totalXp = predict.stats.totalXp + trivia.totalXp;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // Live ticker
              const SafeArea(bottom: false, child: LiveTicker()),
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('CricPulse', style: tt.headlineLarge!.copyWith(color: cs.primary)),
                    const SizedBox(height: 4),
                    Text('Fan Live Companion', style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 20),

                    // Quick Stats
                    Row(
                      children: [
                        _StatChip(label: 'Live', value: '${live.length}', icon: Icons.circle, color: cs.error),
                        const SizedBox(width: 12),
                        _StatChip(label: 'XP', value: '$totalXp', icon: Icons.star, color: cs.tertiary),
                        const SizedBox(width: 12),
                        _StatChip(label: 'Streak', value: '${predict.stats.currentStreak}', icon: Icons.local_fire_department, color: cs.secondary),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Hero live match
                    if (live.isNotEmpty) ...[
                      Text('Live Now', style: tt.headlineSmall),
                      const SizedBox(height: 12),
                      HeroMatchCard(
                        match: live.first,
                        onTap: () => context.push('/match/${live.first.id}'),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Feature panels
                    Text('Fan Zone', style: tt.headlineSmall),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.1,
                      children: [
                        _FeatureCard(
                          icon: Icons.poll,
                          label: 'Crowd Polls',
                          subtitle: 'Vote live',
                          color: cs.primaryContainer,
                          onTap: () => context.push('/polls'),
                        ),
                        _FeatureCard(
                          icon: Icons.quiz,
                          label: 'Cricket Trivia',
                          subtitle: '${trivia.roundsPlayed} rounds played',
                          color: cs.secondary,
                          onTap: () => context.push('/trivia'),
                        ),
                        _FeatureCard(
                          icon: Icons.gps_fixed,
                          label: 'Predict Ball',
                          subtitle: '${predict.stats.accuracy.toStringAsFixed(0)}% accuracy',
                          color: const Color(0xFF4285F4),
                          onTap: () => context.push('/predict'),
                        ),
                        _FeatureCard(
                          icon: Icons.smart_toy,
                          label: 'CricBot AI',
                          subtitle: 'Ask anything',
                          color: cs.tertiary,
                          onTap: () => context.push('/chat'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        borderRadius: 16,
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: tt.headlineMedium!.copyWith(color: color)),
            Text(label, style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return GlassCard(
      onTap: onTap,
      borderRadius: 20,
      glowColor: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(label, style: tt.titleSmall!.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(subtitle, style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
