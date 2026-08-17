import 'package:flutter/material.dart';

import '../services/haptics.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 38), // Breathable bottom margin
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            28,
          ), // Outer pill container wrapper
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavButton(
              icon: Icons.home_rounded,
              isSelected: currentIndex == 0,
              onTap: () {
                if (currentIndex != 0) {
                  Haptics.selection();
                  onTap(0);
                }
              },
            ),
            const SizedBox(width: 4),
            _NavButton(
              icon: Icons.grid_view_rounded,
              isSelected: currentIndex == 1,
              onTap: () {
                if (currentIndex != 1) {
                  Haptics.selection();
                  onTap(1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF121017) : Colors.transparent,
          borderRadius: BorderRadius.circular(
            22,
          ), // Prominent squircle active indicator
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: isSelected ? Colors.white : const Color(0xFF121017),
          ),
        ),
      ),
    );
  }
}
