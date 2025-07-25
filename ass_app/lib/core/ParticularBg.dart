
import 'package:ass_app/models/particule.dart';
import 'package:flutter/material.dart';

class ParticleBackground extends StatelessWidget {
  final List<Particle> particles;
  final AnimationController particleController;

  const ParticleBackground({
    super.key,
    required this.particles,
    required this.particleController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, particleController.value),
          size: Size.infinite,
        );
      },
    );
  }
}