import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/matches_provider.dart';
import '../../widgets/match_card.dart';
import '../../widgets/segmented_control.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Consumer<MatchesProvider>(
      builder: (context, prov, _) {
        final matches = prov.filteredMatches;
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text('Matches')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: SegmentedControl(
                  labels: MatchesProvider.tabLabels,
                  selectedIndex: prov.selectedTab,
                  onChanged: prov.setTab,
                ),
              ),
              Expanded(
                child: matches.isEmpty
                    ? Center(child: Text('No matches found', style: tt.bodyLarge))
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: matches.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => MatchCard(
                          match: matches[i],
                          onTap: () => context.push('/match/${matches[i].id}'),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
