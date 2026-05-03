import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/live_scores_provider.dart';

class LiveTicker extends StatelessWidget {
  const LiveTicker({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<LiveScoresProvider>(
      builder: (context, prov, _) {
        final live = prov.liveMatches;
        if (live.isEmpty) return const SizedBox.shrink();

        final match = live.first;
        final inn = match.activeInnings;
        final teamCode = inn?.battingTeamId == match.homeTeam.id
            ? match.homeTeam.shortCode
            : match.awayTeam.shortCode;
        final scoreText = inn != null
            ? '$teamCode ${inn.scoreString} (${inn.overs.toStringAsFixed(1)})'
            : '${match.homeTeam.shortCode} vs ${match.awayTeam.shortCode}';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F0F).withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(color: cs.primaryContainer, width: 4),
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            boxShadow: [
              BoxShadow(
                color: cs.primaryContainer.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _PulsingDot(color: cs.error),
              const SizedBox(width: 8),
              Text(
                scoreText,
                style: tt.headlineSmall!.copyWith(
                  color: cs.primaryContainer,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cs.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: cs.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'LIVE',
                      style: tt.labelSmall!.copyWith(
                        color: cs.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Icon(
          Icons.sensors,
          color: widget.color.withValues(alpha: 0.4 + _ctrl.value * 0.6),
          size: 20,
        );
      },
    );
  }
}
