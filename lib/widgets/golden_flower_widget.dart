import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class GoldenFlowerWidget extends StatelessWidget {
  final GoldenFlower goldenFlower;
  
  const GoldenFlowerWidget({
    Key? key,
    required this.goldenFlower,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (goldenFlower.isCollected) return const SizedBox.shrink();
    
    return Positioned(
      left: goldenFlower.x,
      top: goldenFlower.y,
      child: Container(
        width: goldenFlower.width,
        height: goldenFlower.height,
        child: Center(
          child: Text(
            '🌻', // Sunflower emoji for golden flower
            style: TextStyle(
              fontSize: 24,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.amber.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 