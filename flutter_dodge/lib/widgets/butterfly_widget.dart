import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class ButterflyWidget extends StatelessWidget {
  final Butterfly butterfly;
  
  const ButterflyWidget({
    Key? key,
    required this.butterfly,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: butterfly.x,
      top: butterfly.y,
      child: Container(
        width: butterfly.width,
        height: butterfly.height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.purple.shade300,
              Colors.purple.shade500,
              Colors.purple.shade700,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Butterfly body
            Center(
              child: Container(
                width: 8,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Left wing
            Positioned(
              left: 2,
              top: 5,
              child: Container(
                width: 15,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.orange.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
            // Right wing
            Positioned(
              right: 2,
              top: 5,
              child: Container(
                width: 15,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.orange.shade300,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
            ),
            // Antennae
            Positioned(
              top: 2,
              left: 15,
              child: Container(
                width: 2,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 15,
              child: Container(
                width: 2,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 