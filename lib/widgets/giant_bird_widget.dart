import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class GiantBirdWidget extends StatelessWidget {
  final GiantBird giantBird;
  final bool hasImmunity;
  final bool isFlashing;
  
  const GiantBirdWidget({
    Key? key,
    required this.giantBird,
    this.hasImmunity = false,
    this.isFlashing = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: giantBird.x,
      top: giantBird.y,
      child: Container(
        width: giantBird.width,
        height: giantBird.height,
        child: Center(
          child: Opacity(
            opacity: hasImmunity ? (isFlashing ? 0.8 : 0.5) : 1.0,
            child: Text(
              '🦅', // Eagle emoji for giant bird
              style: TextStyle(
                fontSize: 48,
                shadows: [
                  Shadow(
                    offset: Offset(3, 3),
                    blurRadius: 6,
                    color: Colors.red.withOpacity(0.4),
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