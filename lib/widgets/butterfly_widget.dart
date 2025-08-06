import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class ButterflyWidget extends StatelessWidget {
  final Butterfly butterfly;
  final bool isDead;

  const ButterflyWidget({
    Key? key,
    required this.butterfly,
    this.isDead = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: butterfly.x,
      top: butterfly.y,
      child: Container(
        width: butterfly.width,
        height: butterfly.height,
        child: Center(
          child: Transform.rotate(
            angle: _getRotationAngle(),
            child: Opacity(
              opacity: isDead ? 0.3 : 1.0,
              child: Text(
                '🐝',
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
        ),
      ),
    );
  }

  double _getRotationAngle() {
    // Make bee face right (away from birds) by default
    // Rotate slightly based on vertical movement
    if (butterfly.y < 300) {
      // Moving up - face slightly up and right
      return 0.2;
    } else if (butterfly.y > 300) {
      // Moving down - face slightly down and right
      return -0.2;
    } else {
      // Neutral position - face right
      return 0.0;
    }
  }
}

class Butterfly2Widget extends StatelessWidget {
  final Butterfly2 butterfly2;
  final bool isDead;

  const Butterfly2Widget({
    Key? key,
    required this.butterfly2,
    this.isDead = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: butterfly2.x,
      top: butterfly2.y,
      child: Container(
        width: butterfly2.width,
        height: butterfly2.height,
        child: Center(
          child: Transform.rotate(
            angle: _getRotationAngle(),
            child: Opacity(
              opacity: isDead ? 0.3 : 1.0,
              child: Text(
                '🦋',
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
        ),
      ),
    );
  }

  double _getRotationAngle() {
    // Make butterfly face right (away from birds) by default
    // Rotate slightly based on vertical movement
    if (butterfly2.y < 300) {
      // Moving up - face slightly up and right
      return 0.2;
    } else if (butterfly2.y > 300) {
      // Moving down - face slightly down and right
      return -0.2;
    } else {
      // Neutral position - face right
      return 0.0;
    }
  }
} 