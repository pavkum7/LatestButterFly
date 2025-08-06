import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class BirdWidget extends StatelessWidget {
  final Bird bird;
  final bool hasImmunity;
  final bool isFlashing;
  
  const BirdWidget({
    Key? key,
    required this.bird,
    this.hasImmunity = false,
    this.isFlashing = false,
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
          child: Opacity(
            opacity: hasImmunity ? (isFlashing ? 0.8 : 0.5) : 1.0,
            child: Text(
              bird.isGiantBird ? '🦅' : '🐦', // Giant bird emoji for some birds
              style: TextStyle(
                fontSize: bird.isGiantBird ? 48 : 32, // Larger size for giant birds
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: bird.isGiantBird 
                      ? Colors.red.withOpacity(0.4) 
                      : Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 