import 'package:flutter/material.dart';
import 'dart:math' as math;

class TypingIndicator extends StatelessWidget {
  final AnimationController controller;

  const TypingIndicator({super.key, required this.controller});

  Widget _buildDot(int index) {
    final delay = index * 0.2;
    final animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Interval(delay, delay + 0.4, curve: Curves.easeInOut)),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.grey.shade400, shape: BoxShape.circle)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const CircleAvatar(radius: 16, backgroundColor: Colors.blue, child: Text('S', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [_buildDot(0), const SizedBox(width: 4), _buildDot(1), const SizedBox(width: 4), _buildDot(2)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}