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
        child: Center(
          child: Text(
            '🌸',
            style: TextStyle(
              fontSize: 24,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 