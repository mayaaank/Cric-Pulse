import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/predict_provider.dart';
import '../../providers/trivia_provider.dart';
import '../../widgets/glass_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final predict = context.watch<PredictProvider>();
    final trivia = context.watch<TriviaProvider>();
    final totalXp = predict.stats.totalXp + trivia.totalXp;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Leaderboard', style: tt.headlineLarge!.copyWith(color: cs.primary)),
            const SizedBox(height: 4),
            Text('Your fan stats & rankings', style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 24),

            // Your stats card
            GlassCard(
              glowColor: cs.primaryContainer,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.primaryContainer,
                    child: const Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text('Cricket Fan', style: tt.titleMedium),
                  const SizedBox(height: 4),
                  Text('Level ${(totalXp / 1000).floor() + 1}', style: tt.labelLarge!.copyWith(color: cs.tertiary)),
                  const SizedBox(height: 16),
                  Text('$totalXp', style: tt.displayLarge!.copyWith(color: cs.primaryContainer)),
                  Text('Total XP', style: tt.labelSmall),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MiniStat(label: 'Predictions', value: '${predict.stats.totalPredictions}', color: cs.primary, tt: tt),
                      _MiniStat(label: 'Accuracy', value: '${predict.stats.accuracy.toStringAsFixed(0)}%', color: cs.secondary, tt: tt),
                      _MiniStat(label: 'Trivia XP', value: '${trivia.totalXp}', color: cs.tertiary, tt: tt),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Top Fans', style: tt.headlineSmall),
            const SizedBox(height: 12),

            // Mock leaderboard entries
            ..._mockLeaderboard(totalXp).asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final fan = entry.value;
              final isYou = fan['name'] == 'You';
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  borderRadius: 16,
                  glowColor: isYou ? cs.primaryContainer : null,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Text(
                          rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : '#$rank',
                          style: tt.labelLarge,
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isYou ? cs.primaryContainer : cs.surfaceContainerHigh,
                        child: Text(
                          (fan['name'] as String)[0],
                          style: tt.labelLarge!.copyWith(color: isYou ? Colors.white : cs.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fan['name'] as String,
                              style: tt.titleSmall!.copyWith(
                                fontWeight: isYou ? FontWeight.w700 : FontWeight.w400,
                                color: isYou ? cs.primary : cs.onSurface,
                              ),
                            ),
                            Text('Level ${fan['level']}', style: tt.labelSmall),
                          ],
                        ),
                      ),
                      Text(
                        '${fan['xp']} XP',
                        style: tt.labelLarge!.copyWith(
                          color: isYou ? cs.primaryContainer : cs.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _mockLeaderboard(int yourXp) {
    final list = [
      {'name': 'CricketKing99', 'xp': 12500, 'level': 13},
      {'name': 'SixHitter_Pro', 'xp': 9800, 'level': 10},
      {'name': 'BowlerBoss', 'xp': 8200, 'level': 9},
      {'name': 'You', 'xp': yourXp, 'level': (yourXp / 1000).floor() + 1},
      {'name': 'SpiritOfCricket', 'xp': 5400, 'level': 6},
      {'name': 'MatchDay_Fan', 'xp': 4100, 'level': 5},
      {'name': 'WicketAlert', 'xp': 3200, 'level': 4},
      {'name': 'RunChaser22', 'xp': 2100, 'level': 3},
    ];
    list.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));
    return list;
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final TextTheme tt;

  const _MiniStat({required this.label, required this.value, required this.color, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: tt.headlineSmall!.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: tt.labelSmall),
      ],
    );
  }
}
