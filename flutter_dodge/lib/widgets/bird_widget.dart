import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class BirdWidget extends StatelessWidget {
  final Bird bird;
  
  const BirdWidget({
    Key? key,
    required this.bird,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: bird.x,
      top: bird.y,
      child: Container(
        width: bird.width,
        height: bird.height,
        child: Center(
          child: Text(
            '🐦',
            style: TextStyle(
              fontSize: 32,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 