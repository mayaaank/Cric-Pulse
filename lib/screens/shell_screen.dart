import 'dart:ui';
import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'leaderboard/leaderboard_screen.dart';
import 'predict/predict_screen.dart';
import 'chat/chat_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    LeaderboardScreen(),
    PredictScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      extendBody: true,
      bottomNavigationBar: _FloatingBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        cs: cs,
      ),
    );
  }
}

class _FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final ColorScheme cs;

  const _FloatingBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.only(top: 12, bottom: 28, left: 24, right: 24),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
                cs: cs,
              ),
              _NavItem(
                icon: Icons.emoji_events,
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
                cs: cs,
              ),
              // Center predict button — raised blue circle
              _PredictButton(
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
                cs: cs,
              ),
              _NavItem(
                icon: Icons.smart_toy,
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
                cs: cs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: isActive ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey.shade600,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _PredictButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  final ColorScheme cs;

  const _PredictButton({
    required this.isActive,
    required this.onTap,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isActive ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: cs.primaryContainer.withValues(alpha: 0.4),
                blurRadius: 15,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(Icons.gps_fixed, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
