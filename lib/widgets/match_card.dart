import 'package:flutter/material.dart';
import '../models/match.dart';
import 'glass_card.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;

  const MatchCard({super.key, required this.match, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final m = match;

    Color statusColor;
    switch (m.status) {
      case MatchStatus.live:
        statusColor = cs.error;
        break;
      case MatchStatus.upcoming:
        statusColor = cs.primaryContainer;
        break;
      case MatchStatus.completed:
        statusColor = cs.secondary;
        break;
    }

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(m.statusLabel, style: tt.labelSmall!.copyWith(color: statusColor, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(m.formatLabel, style: tt.labelSmall),
              ),
              const Spacer(),
              Text(
                _formatDate(m.dateTime),
                style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(m.homeTeam.flagEmoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(m.homeTeam.name, style: tt.titleSmall),
              ),
              if (m.innings1 != null)
                Text(m.innings1!.scoreString, style: tt.titleMedium!.copyWith(color: cs.primary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(m.awayTeam.flagEmoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(m.awayTeam.name, style: tt.titleSmall),
              ),
              if (m.innings2 != null)
                Text(m.innings2!.scoreString, style: tt.titleMedium!.copyWith(color: cs.secondary)),
            ],
          ),
          if (m.result != null) ...[
            const SizedBox(height: 8),
            Text(m.result!, style: tt.bodySmall!.copyWith(color: cs.secondary)),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(m.venue, style: tt.labelSmall!.copyWith(color: cs.onSurfaceVariant), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}
