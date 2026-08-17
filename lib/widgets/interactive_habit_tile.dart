import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../services/haptics.dart';

class InteractiveHabitTile extends StatelessWidget {
  const InteractiveHabitTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.onToggle,
    this.tag,
  });

  final String title;
  final String subtitle;
  final bool completed;
  final VoidCallback onToggle;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptics.success();
        onToggle();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: completed ? AppTheme.mintTint : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: completed
                ? AppTheme.mintGreen.withValues(alpha: 0.3)
                : AppTheme.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: completed ? 0.02 : 0.03),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed ? AppTheme.mintGreen : AppTheme.surfaceSubtle,
                border: Border.all(
                  color: completed
                      ? AppTheme.mintGreen
                      : const Color(0xFFD6CBEC),
                  width: 2,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: completed
                    ? const Icon(
                        Icons.check_rounded,
                        key: ValueKey('check'),
                        size: 20,
                        color: Colors.white,
                      )
                    : const SizedBox(key: ValueKey('empty')),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: completed
                          ? AppTheme.darkText.withValues(alpha: 0.6)
                          : AppTheme.darkText,
                      decoration: completed ? TextDecoration.lineThrough : null,
                      decorationColor: AppTheme.mutedText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            if (tag != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: completed
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppTheme.surfaceSubtle,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  tag!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: completed
                        ? AppTheme.mintGreen
                        : AppTheme.primaryPurple,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
