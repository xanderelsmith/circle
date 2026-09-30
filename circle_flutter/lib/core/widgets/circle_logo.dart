import 'package:flutter/material.dart';
import '../../../../theme.dart';

/// Shared brand mark — used on Home AppBar AND Leaderboards header.
class CircleLogo extends StatelessWidget {
  const CircleLogo({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.secondary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        Icons.circle_outlined,
        color: AppTheme.cyan,
        size: size * 0.6,
      ),
    );
  }
}
