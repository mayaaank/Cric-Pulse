import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/poll_provider.dart';
import '../../widgets/poll_card.dart';

class PollsScreen extends StatelessWidget {
  const PollsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<PollProvider>(
      builder: (context, prov, _) {
        final polls = prov.polls;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Text('Crowd Polls',
                      style: tt.headlineLarge!.copyWith(color: cs.primary)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Vote on live match moments!',
                      style: tt.bodySmall!.copyWith(color: cs.onSurfaceVariant)),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: polls.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.poll, size: 64, color: cs.onSurfaceVariant),
                              const SizedBox(height: 16),
                              Text('No active polls', style: tt.bodyLarge),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: polls.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, i) {
                            final poll = polls[i];
                            return PollCard(
                              poll: poll,
                              hasVoted: prov.hasVoted(poll.id),
                              onVote: (option) => prov.vote(poll.id, option),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
