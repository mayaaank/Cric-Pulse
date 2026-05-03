import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/prediction.dart';
import '../../providers/predict_provider.dart';
import '../../widgets/predict_tile.dart';
import '../../widgets/glass_card.dart';

class PredictScreen extends StatelessWidget {
  const PredictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Consumer<PredictProvider>(
      builder: (context, prov, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Subtle watermark
              Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.sports_cricket,
                    size: 300,
                    color: Colors.white.withValues(alpha: 0.03),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // Header
                      Text(
                        'Predict Next Ball',
                        style: tt.headlineLarge!.copyWith(color: cs.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${prov.currentOverInfo} • ${prov.currentBowler} to ${prov.currentBatsman}',
                        style: tt.bodyMedium!.copyWith(color: cs.onSurfaceVariant),
                      ),

                      // Multiplier badge
                      if (prov.stats.multiplier > 1) ...[
                        const SizedBox(height: 10),
                        GlassCard(
                          borderRadius: 9999,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          glowColor: cs.primaryContainer,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_fire_department,
                                  color: cs.tertiary, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '${prov.stats.multiplier}x Multiplier Active!',
                                style: tt.labelLarge!.copyWith(color: cs.tertiary),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Stats bar
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              label: 'Accuracy',
                              value: '${prov.stats.accuracy.toStringAsFixed(0)}%',
                              color: cs.secondary,
                            ),
                            _StatItem(
                              label: 'Streak',
                              value: '${prov.stats.currentStreak}',
                              color: cs.tertiary,
                            ),
                            _StatItem(
                              label: 'XP',
                              value: '${prov.stats.totalXp}',
                              color: cs.primary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2x2 prediction grid
                      if (prov.waitingForResult)
                        _WaitingOverlay(
                          predicted: prov.pendingPrediction!,
                          cs: cs,
                          tt: tt,
                        )
                      else
                        GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            PredictTile(
                              label: 'DOT',
                              xpText: '+10 XP',
                              color: cs.onSurfaceVariant,
                              isCircleIcon: true,
                              onTap: () => prov.makePrediction(BallOutcome.dot),
                            ),
                            PredictTile(
                              label: 'FOUR/SIX',
                              xpText: '+50 XP',
                              icon: Icons.sports_cricket,
                              color: const Color(0xFF34A853),
                              onTap: () => prov.makePrediction(BallOutcome.boundary),
                            ),
                            PredictTile(
                              label: 'WICKET',
                              xpText: '+100 XP',
                              icon: Icons.view_agenda,
                              color: const Color(0xFFEA4335),
                              onTap: () => prov.makePrediction(BallOutcome.wicket),
                            ),
                            PredictTile(
                              label: '1, 2 or 3',
                              xpText: '+25 XP',
                              icon: Icons.directions_run,
                              color: const Color(0xFF4285F4),
                              onTap: () => prov.makePrediction(BallOutcome.runs),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Stake bar
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on, color: cs.tertiary),
                            const SizedBox(width: 8),
                            Text(
                              'Your Stake: ${prov.stake} Coins',
                              style: tt.labelLarge,
                            ),
                            const Spacer(),
                            Text(
                              'Balance: ${prov.coins}',
                              style: tt.labelLarge!.copyWith(color: cs.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Recent predictions
                      if (prov.predictions.isNotEmpty) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Recent Predictions', style: tt.headlineSmall),
                        ),
                        const SizedBox(height: 12),
                        ...prov.predictions.take(5).map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GlassCard(
                                padding: const EdgeInsets.all(12),
                                borderRadius: 12,
                                child: Row(
                                  children: [
                                    Icon(
                                      p.isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: p.isCorrect ? cs.secondary : cs.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Predicted: ${Prediction.labelFor(p.predicted)}',
                                        style: tt.labelLarge,
                                      ),
                                    ),
                                    if (p.actual != null)
                                      Text(
                                        'Actual: ${Prediction.labelFor(p.actual!)}',
                                        style: tt.labelSmall!.copyWith(
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                    if (p.xpEarned > 0) ...[
                                      const SizedBox(width: 8),
                                      Text(
                                        '+${p.xpEarned} XP',
                                        style: tt.labelSmall!.copyWith(
                                          color: cs.tertiary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            )),
                      ],
                      const SizedBox(height: 100),
                    ],
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(value,
            style: tt.headlineMedium!.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: tt.labelSmall),
      ],
    );
  }
}

class _WaitingOverlay extends StatefulWidget {
  final BallOutcome predicted;
  final ColorScheme cs;
  final TextTheme tt;

  const _WaitingOverlay({
    required this.predicted,
    required this.cs,
    required this.tt,
  });

  @override
  State<_WaitingOverlay> createState() => _WaitingOverlayState();
}

class _WaitingOverlayState extends State<_WaitingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(40),
      glowColor: widget.cs.primaryContainer,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Column(
            children: [
              Transform.scale(
                scale: 0.9 + _ctrl.value * 0.1,
                child: Icon(
                  Icons.sports_cricket,
                  size: 64,
                  color: widget.cs.primaryContainer
                      .withValues(alpha: 0.5 + _ctrl.value * 0.5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You predicted: ${Prediction.labelFor(widget.predicted)}',
                style: widget.tt.titleMedium!.copyWith(color: widget.cs.primary),
              ),
              const SizedBox(height: 8),
              Text(
                'Waiting for delivery...',
                style: widget.tt.bodySmall!.copyWith(color: widget.cs.onSurfaceVariant),
              ),
            ],
          );
        },
      ),
    );
  }
}
