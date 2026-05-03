import 'package:flutter/material.dart';
import '../models/poll.dart';
import 'glass_card.dart';

class PollCard extends StatelessWidget {
  final Poll poll;
  final bool hasVoted;
  final ValueChanged<String>? onVote;

  const PollCard({
    super.key,
    required this.poll,
    this.hasVoted = false,
    this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.poll, color: cs.primaryContainer, size: 20),
              const SizedBox(width: 8),
              Text(
                '${poll.totalVotes} votes',
                style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant),
              ),
              const Spacer(),
              if (hasVoted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    'VOTED',
                    style: tt.labelSmall!.copyWith(
                      color: cs.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(poll.question, style: tt.titleMedium),
          const SizedBox(height: 16),
          ...poll.options.map((option) {
            final pct = poll.percentage(option);
            final votes = poll.votes[option] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: hasVoted
                  ? _ResultBar(
                      option: option,
                      percentage: pct,
                      votes: votes,
                      cs: cs,
                      tt: tt,
                    )
                  : _VoteButton(
                      option: option,
                      onTap: () => onVote?.call(option),
                      cs: cs,
                      tt: tt,
                    ),
            );
          }),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final String option;
  final VoidCallback onTap;
  final ColorScheme cs;
  final TextTheme tt;

  const _VoteButton({
    required this.option,
    required this.onTap,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Text(
            option,
            style: tt.labelLarge!.copyWith(color: cs.onSurface),
          ),
        ),
      ),
    );
  }
}

class _ResultBar extends StatelessWidget {
  final String option;
  final double percentage;
  final int votes;
  final ColorScheme cs;
  final TextTheme tt;

  const _ResultBar({
    required this.option,
    required this.percentage,
    required this.votes,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(option, style: tt.labelLarge),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: tt.labelLarge!.copyWith(
                color: cs.primaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percentage / 100),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: cs.surfaceContainerHigh,
                color: cs.primaryContainer,
              );
            },
          ),
        ),
      ],
    );
  }
}
