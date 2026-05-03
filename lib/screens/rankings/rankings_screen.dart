import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rankings_provider.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/segmented_control.dart';

class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<RankingsProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Rankings')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SegmentedControl(
                  labels: RankingsProvider.categoryLabels,
                  selectedIndex: prov.category.index,
                  onChanged: prov.setCategory,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildTable(context, prov, cs, tt),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context, RankingsProvider prov, ColorScheme cs, TextTheme tt) {
    switch (prov.category) {
      case RankingCategory.batsmen:
        return _batsmenTable(context, prov, cs, tt);
      case RankingCategory.bowlers:
        return _bowlersTable(context, prov, cs, tt);
      case RankingCategory.teams:
        return _teamsTable(context, prov, cs, tt);
    }
  }

  String _medal(int rank) {
    switch (rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '#$rank';
    }
  }

  Widget _sortHeader(BuildContext context, RankingsProvider prov, int col, String label) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final active = prov.sortColumn == col;
    return GestureDetector(
      onTap: () => prov.toggleSort(col),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: tt.labelSmall!.copyWith(
            color: active ? cs.primaryContainer : cs.onSurfaceVariant,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          )),
          if (active)
            Icon(prov.sortAsc ? Icons.arrow_upward : Icons.arrow_downward, size: 12, color: cs.primaryContainer),
        ],
      ),
    );
  }

  Widget _batsmenTable(BuildContext context, RankingsProvider prov, ColorScheme cs, TextTheme tt) {
    final players = prov.rankedBatsmen;
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                SizedBox(width: 36, child: _sortHeader(context, prov, 0, '#')),
                Expanded(flex: 3, child: Text('Player', style: tt.labelSmall)),
                Expanded(child: _sortHeader(context, prov, 1, 'Runs')),
                Expanded(child: _sortHeader(context, prov, 2, 'Avg')),
                Expanded(child: _sortHeader(context, prov, 3, 'SR')),
                Expanded(child: _sortHeader(context, prov, 4, '100s')),
              ],
            ),
          ),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.3), height: 1),
          ...players.map((p) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                SizedBox(width: 36, child: Text(_medal(p.battingRank), style: tt.labelLarge)),
                Expanded(flex: 3, child: Text(p.name, style: tt.labelLarge, overflow: TextOverflow.ellipsis)),
                Expanded(child: Text('${p.battingStats.runs}', style: tt.labelMedium!.copyWith(color: cs.primary))),
                Expanded(child: Text(p.battingStats.average.toStringAsFixed(1), style: tt.labelMedium)),
                Expanded(child: Text(p.battingStats.strikeRate.toStringAsFixed(1), style: tt.labelMedium)),
                Expanded(child: Text('${p.battingStats.hundreds}', style: tt.labelMedium)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _bowlersTable(BuildContext context, RankingsProvider prov, ColorScheme cs, TextTheme tt) {
    final players = prov.rankedBowlers;
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                SizedBox(width: 36, child: _sortHeader(context, prov, 0, '#')),
                Expanded(flex: 3, child: Text('Player', style: tt.labelSmall)),
                Expanded(child: _sortHeader(context, prov, 1, 'Wkts')),
                Expanded(child: _sortHeader(context, prov, 2, 'Econ')),
                Expanded(child: _sortHeader(context, prov, 3, 'Avg')),
              ],
            ),
          ),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.3), height: 1),
          ...players.map((p) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                SizedBox(width: 36, child: Text(_medal(p.bowlingRank), style: tt.labelLarge)),
                Expanded(flex: 3, child: Text(p.name, style: tt.labelLarge, overflow: TextOverflow.ellipsis)),
                Expanded(child: Text('${p.bowlingStats.wickets}', style: tt.labelMedium!.copyWith(color: cs.tertiary))),
                Expanded(child: Text(p.bowlingStats.economy.toStringAsFixed(1), style: tt.labelMedium)),
                Expanded(child: Text(p.bowlingStats.average.toStringAsFixed(1), style: tt.labelMedium)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _teamsTable(BuildContext context, RankingsProvider prov, ColorScheme cs, TextTheme tt) {
    final teams = prov.rankedTeams;
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                SizedBox(width: 36, child: _sortHeader(context, prov, 0, '#')),
                Expanded(flex: 3, child: Text('Team', style: tt.labelSmall)),
                Expanded(child: _sortHeader(context, prov, 1, 'W')),
                Expanded(child: _sortHeader(context, prov, 2, 'M')),
                Expanded(child: _sortHeader(context, prov, 3, 'Win%')),
              ],
            ),
          ),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.3), height: 1),
          ...teams.map((t) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                SizedBox(width: 36, child: Text(_medal(t.iccRanking), style: tt.labelLarge)),
                Expanded(flex: 3, child: Row(
                  children: [
                    Text(t.flagEmoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Expanded(child: Text(t.name, style: tt.labelLarge, overflow: TextOverflow.ellipsis)),
                  ],
                )),
                Expanded(child: Text('${t.wins}', style: tt.labelMedium!.copyWith(color: cs.secondary))),
                Expanded(child: Text('${t.matchesPlayed}', style: tt.labelMedium)),
                Expanded(child: Text('${t.winPercentage.toStringAsFixed(0)}%', style: tt.labelMedium)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
