import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../models/match.dart';
import '../../providers/live_scores_provider.dart';
import '../../widgets/hero_match_card.dart';
import '../../widgets/match_card.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/xp_progress_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<LiveScoresProvider>(
      builder: (context, prov, _) {
        final live = prov.liveMatches;
        final upcoming = prov.allMatches
            .where((m) => m.status == MatchStatus.upcoming)
            .toList();
        final completed = prov.allMatches
            .where((m) => m.status == MatchStatus.completed)
            .toList();

        return RefreshIndicator(
          color: cs.primaryContainer,
          backgroundColor: cs.surfaceContainer,
          onRefresh: prov.refresh,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('CricPulse', style: tt.headlineLarge!.copyWith(color: cs.primary)),
              const SizedBox(height: 4),
              Text('High-Octane Cricket', style: tt.bodySmall),
              const SizedBox(height: 20),

              // Quick Stats
              Row(
                children: [
                  _StatChip(label: 'Today', value: '${live.length + upcoming.length}', icon: Icons.today, color: cs.primaryContainer),
                  const SizedBox(width: 12),
                  _StatChip(label: 'Live', value: '${live.length}', icon: Icons.circle, color: cs.error),
                  const SizedBox(width: 12),
                  _StatChip(label: 'Done', value: '${completed.length}', icon: Icons.check_circle_outline, color: cs.secondary),
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

              // XP Progress
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: XpProgressBar(
                  progress: 0.68,
                  label: 'Fan Level 12',
                  currentXp: 6800,
                  maxXp: 10000,
                ),
              ),
              const SizedBox(height: 24),

              // Upcoming
              if (upcoming.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming Matches', style: tt.headlineSmall),
                    TextButton(
                      onPressed: () {},
                      child: Text('See All', style: tt.labelLarge!.copyWith(color: cs.primaryContainer)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: upcoming.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => SizedBox(
                      width: 300,
                      child: MatchCard(
                        match: upcoming[i],
                        onTap: () => context.push('/match/${upcoming[i].id}'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Recent Results
              if (completed.isNotEmpty) ...[
                Text('Recent Results', style: tt.headlineSmall),
                const SizedBox(height: 12),
                ...completed.take(3).map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MatchCard(
                    match: m,
                    onTap: () => context.push('/match/${m.id}'),
                  ),
                )),
              ],
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
