import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class PurpleFlowerWidget extends StatelessWidget {
  final PurpleFlower purpleFlower;
  
  const PurpleFlowerWidget({
    Key? key,
    required this.purpleFlower,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (purpleFlower.isCollected) return const SizedBox.shrink();
    
    return Positioned(
      left: purpleFlower.x,
      top: purpleFlower.y,
      child: Container(
        width: purpleFlower.width,
        height: purpleFlower.height,
        child: Center(
          child: Text(
            '💜', // Purple heart emoji for purple flower
            style: TextStyle(
              fontSize: 24,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.purple.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 