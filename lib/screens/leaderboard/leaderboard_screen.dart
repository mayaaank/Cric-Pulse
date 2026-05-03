import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/predict_provider.dart';
import '../../providers/trivia_provider.dart';
import '../../services/leaderboard_service.dart';
import '../../widgets/glass_card.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _service = LeaderboardService();
  List<LeaderboardEntry> _topUsers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final users = await _service.getTopUsers(limit: 20);
    if (mounted) {
      setState(() {
        _topUsers = users;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final predict = context.watch<PredictProvider>();
    final trivia = context.watch<TriviaProvider>();
    final auth = context.watch<AuthProvider>();

    final localXp = predict.stats.totalXp + trivia.totalXp;
    final profileXp = auth.profile?.totalXp ?? 0;
    final totalXp = profileXp > 0 ? profileXp : localXp;
    final userName = auth.profile?.displayName ?? auth.profile?.username ?? 'Cricket Fan';
    final level = auth.profile?.level ?? ((totalXp / 1000).floor() + 1);

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
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: tt.headlineLarge!.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(userName, style: tt.titleMedium),
                  const SizedBox(height: 4),
                  Text('Level $level', style: tt.labelLarge!.copyWith(color: cs.tertiary)),
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

            if (_loading)
              const Center(child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ))
            else if (_topUsers.isEmpty)
              // Fallback to mock leaderboard if Supabase has no data
              ..._buildMockLeaderboard(totalXp, userName, level, cs, tt)
            else
              ..._buildRealLeaderboard(auth.userId, cs, tt),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRealLeaderboard(String? currentUserId, ColorScheme cs, TextTheme tt) {
    return _topUsers.asMap().entries.map((entry) {
      final rank = entry.key + 1;
      final user = entry.value;
      final isYou = user.userId == currentUserId;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _LeaderboardRow(
          rank: rank,
          name: user.name,
          xp: user.totalXp,
          level: user.level,
          isYou: isYou,
          cs: cs,
          tt: tt,
        ),
      );
    }).toList();
  }

  List<Widget> _buildMockLeaderboard(int yourXp, String yourName, int yourLevel, ColorScheme cs, TextTheme tt) {
    final list = [
      {'name': 'CricketKing99', 'xp': 12500, 'level': 13},
      {'name': 'SixHitter_Pro', 'xp': 9800, 'level': 10},
      {'name': 'BowlerBoss', 'xp': 8200, 'level': 9},
      {'name': yourName, 'xp': yourXp, 'level': yourLevel, 'isYou': true},
      {'name': 'SpiritOfCricket', 'xp': 5400, 'level': 6},
      {'name': 'MatchDay_Fan', 'xp': 4100, 'level': 5},
      {'name': 'WicketAlert', 'xp': 3200, 'level': 4},
      {'name': 'RunChaser22', 'xp': 2100, 'level': 3},
    ];
    list.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));

    return list.asMap().entries.map((entry) {
      final rank = entry.key + 1;
      final fan = entry.value;
      final isYou = fan['isYou'] == true;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _LeaderboardRow(
          rank: rank,
          name: fan['name'] as String,
          xp: fan['xp'] as int,
          level: fan['level'] as int,
          isYou: isYou,
          cs: cs,
          tt: tt,
        ),
      );
    }).toList();
  }
}

class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final int xp;
  final int level;
  final bool isYou;
  final ColorScheme cs;
  final TextTheme tt;

  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.xp,
    required this.level,
    required this.isYou,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
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
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: tt.labelLarge!.copyWith(color: isYou ? Colors.white : cs.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isYou ? '$name (You)' : name,
                  style: tt.titleSmall!.copyWith(
                    fontWeight: isYou ? FontWeight.w700 : FontWeight.w400,
                    color: isYou ? cs.primary : cs.onSurface,
                  ),
                ),
                Text('Level $level', style: tt.labelSmall),
              ],
            ),
          ),
          Text(
            '$xp XP',
            style: tt.labelLarge!.copyWith(
              color: isYou ? cs.primaryContainer : cs.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
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
