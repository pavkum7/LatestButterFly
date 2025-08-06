import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class FlowerWidget extends StatelessWidget {
  final Flower flower;
  
  const FlowerWidget({
    Key? key,
    required this.flower,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (flower.isCollected) return const SizedBox.shrink();
    
    return Positioned(
      left: flower.x,
      top: flower.y,
      child: Container(
        width: flower.width,
        height: flower.height,
        child: Stack(
          children: [
            // Flower petals
            Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.pink.shade200,
                      Colors.pink.shade400,
                      Colors.pink.shade600,
                    ],
                  ),
                ),
              ),
            ),
            // Petal 1
            Positioned(
              top: 2,
              left: 8,
              child: Container(
                width: 12,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.pink.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Petal 2
            Positioned(
              top: 2,
              right: 8,
              child: Container(
                width: 12,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.pink.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Petal 3
            Positioned(
              bottom: 2,
              left: 8,
              child: Container(
                width: 12,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.pink.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Petal 4
            Positioned(
              bottom: 2,
              right: 8,
              child: Container(
                width: 12,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.pink.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            // Flower center
            Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow.shade600,
                ),
              ),
            ),
            // Stem
            Positioned(
              bottom: -5,
              left: 13,
              child: Container(
                width: 4,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 