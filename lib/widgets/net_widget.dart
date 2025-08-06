import 'package:flutter/material.dart';
import '../models/game_entities.dart';

class NetWidget extends StatelessWidget {
  final Net net;
  final bool hasImmunity;
  final bool isFlashing;
  
  const NetWidget({
    Key? key,
    required this.net,
    this.hasImmunity = false,
    this.isFlashing = false,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (net.isCollected) return const SizedBox.shrink();
    
    return Positioned(
      left: net.x,
      top: net.y,
      child: Container(
        width: net.width,
        height: net.height,
        child: Center(
          child: Opacity(
            opacity: hasImmunity ? (isFlashing ? 0.8 : 0.5) : 1.0,
            child: Text(
              '🕸️', // Spider web emoji for net
              style: TextStyle(
                fontSize: 32,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.grey.withOpacity(0.4),
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