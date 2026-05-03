import 'dart:ui';
import 'package:flutter/material.dart';

class PredictTile extends StatefulWidget {
  final String label;
  final String xpText;
  final IconData? icon;
  final Color color;
  final bool isCircleIcon;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const PredictTile({
    super.key,
    required this.label,
    required this.xpText,
    this.icon,
    required this.color,
    this.isCircleIcon = false,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  State<PredictTile> createState() => _PredictTileState();
}

class _PredictTileState extends State<PredictTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _scaleCtrl.forward(),
        onTapUp: (_) {
          _scaleCtrl.reverse();
          if (!widget.isDisabled) widget.onTap?.call();
        },
        onTapCancel: () => _scaleCtrl.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: widget.isSelected ? 0.12 : 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? widget.color
                  : widget.color.withValues(alpha: 0.5),
              width: widget.isSelected ? 2.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: widget.isSelected ? 0.3 : 0.15),
                blurRadius: widget.isSelected ? 20 : 15,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.isCircleIcon
                            ? Colors.transparent
                            : widget.color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: widget.isCircleIcon
                            ? Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: widget.color,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Icon(widget.icon, color: widget.color, size: 28),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Spline Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 28 / 20,
                        color: widget.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.xpText,
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: widget.color.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
