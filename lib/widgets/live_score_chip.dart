import 'package:flutter/material.dart';

class LiveScoreChip extends StatelessWidget {
  final String text;
  final Color? color;

  const LiveScoreChip({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Color bgColor;
    Color textColor;

    if (text == 'W') {
      bgColor = cs.error.withValues(alpha: 0.2);
      textColor = cs.error;
    } else if (text == '4' || text == '6') {
      bgColor = cs.secondary.withValues(alpha: 0.2);
      textColor = cs.secondary;
    } else {
      bgColor = cs.surfaceContainerHighest;
      textColor = cs.onSurfaceVariant;
    }

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color != null ? color!.withValues(alpha: 0.2) : bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: color ?? textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
