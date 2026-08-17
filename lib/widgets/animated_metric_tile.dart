import 'package:flutter/material.dart';

import '../services/haptics.dart';

class AnimatedMetricTile extends StatefulWidget {
  const AnimatedMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.delay,
    required this.tint,
  });

  final String label;
  final String value;
  final Duration delay;
  final Color tint;

  @override
  State<AnimatedMetricTile> createState() => _AnimatedMetricTileState();
}

class _AnimatedMetricTileState extends State<AnimatedMetricTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _pressed = true;
    });
    Haptics.light();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _pressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final entry = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (widget.delay.inMilliseconds / 1000).clamp(0.0, 0.8),
            1,
            curve: Curves.easeOutCubic,
          ),
        );

        return Opacity(
          opacity: entry.value,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - entry.value)),
            child: Transform.scale(scale: _pressed ? 0.98 : 1, child: child),
          ),
        );
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: widget.tint.withValues(alpha: 0.45)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF17131E),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF6B6578)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
