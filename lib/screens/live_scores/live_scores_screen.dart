import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/live_scores_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/live_score_chip.dart';

class LiveScoresScreen extends StatelessWidget {
  const LiveScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<LiveScoresProvider>(
      builder: (context, prov, _) {
        final live = prov.liveMatches;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Live Scores'),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: cs.error, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('${live.length} Live', style: tt.labelSmall!.copyWith(color: cs.error, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          body: live.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sports_cricket, size: 64, color: cs.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text('No live matches', style: tt.bodyLarge!.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: live.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final m = live[i];
                    final inn = m.activeInnings;

                    return GlassCard(
                      onTap: () => context.push('/match/${m.id}'),
                      glowColor: cs.primaryContainer,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: cs.error.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(width: 6, height: 6, decoration: BoxDecoration(color: cs.error, shape: BoxShape.circle)),
                                    const SizedBox(width: 4),
                                    Text('LIVE', style: tt.labelSmall!.copyWith(color: cs.error, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(m.formatLabel, style: tt.labelSmall),
                              const Spacer(),
                              if (inn != null) Text(inn.oversString, style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _TeamRow(
                            flag: m.homeTeam.flagEmoji,
                            name: m.homeTeam.name,
                            score: m.innings1?.scoreString ?? '-',
                            isActive: inn?.battingTeamId == m.homeTeam.id,
                          ),
                          const SizedBox(height: 10),
                          _TeamRow(
                            flag: m.awayTeam.flagEmoji,
                            name: m.awayTeam.name,
                            score: m.innings2?.scoreString ?? '-',
                            isActive: inn?.battingTeamId == m.awayTeam.id,
                          ),
                          if (inn?.striker != null) ...[
                            Divider(height: 24, color: cs.outlineVariant.withValues(alpha: 0.3)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${inn!.striker!.name} ${inn.striker!.runs}(${inn.striker!.balls})',
                                  style: tt.labelLarge!.copyWith(color: cs.primary),
                                ),
                                if (inn.currentBowler != null)
                                  Text(
                                    '${inn.currentBowler!.name} ${inn.currentBowler!.wickets}/${inn.currentBowler!.runsConceded}',
                                    style: tt.labelLarge!.copyWith(color: cs.tertiary),
                                  ),
                              ],
                            ),
                          ],
                          if (inn != null && inn.recentBalls.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text('Recent: ', style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant)),
                                ...inn.recentBalls.map((b) => Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: LiveScoreChip(text: b),
                                )),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _TeamRow extends StatelessWidget {
  final String flag;
  final String name;
  final String score;
  final bool isActive;

  const _TeamRow({required this.flag, required this.name, required this.score, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Expanded(child: Text(name, style: tt.titleSmall!.copyWith(fontWeight: isActive ? FontWeight.w700 : FontWeight.w400))),
        Text(score, style: tt.headlineSmall!.copyWith(color: isActive ? cs.primary : cs.onSurfaceVariant)),
      ],
    );
  }
}
