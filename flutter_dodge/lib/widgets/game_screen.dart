import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_state.dart';
import '../models/game_entities.dart';
import 'butterfly_widget.dart';
import 'flower_widget.dart';
import 'net_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;
  Timer? gameTimer;
  bool isMovingUp = false;
  bool isMovingDown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  void _initializeGame() {
    final size = MediaQuery.of(context).size;
    gameState = GameState(
      screenWidth: size.width,
      screenHeight: size.height,
    );
    _startGameLoop();
  }

  void _startGameLoop() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          gameState.update();
          
          // Handle continuous movement
          if (isMovingUp) {
            gameState.moveButterflyUp();
          }
          if (isMovingDown) {
            gameState.moveButterflyDown();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _resetGame() {
    setState(() {
      gameState.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (gameState.status == GameStatus.playing) {
          setState(() {
            if (details.delta.dy < 0) {
              gameState.moveButterflyUp();
            } else if (details.delta.dy > 0) {
              gameState.moveButterflyDown();
            }
          });
        }
      },
      onTapDown: (details) {
        if (gameState.status == GameStatus.playing) {
          final screenHeight = MediaQuery.of(context).size.height;
          final tapY = details.localPosition.dy;
          final screenCenter = screenHeight / 2;
          
          setState(() {
            if (tapY < screenCenter) {
              gameState.moveButterflyUp();
            } else {
              gameState.moveButterflyDown();
            }
          });
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue.shade200,
                Colors.lightBlue.shade400,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background clouds
              _buildBackground(),
              
              // Game elements
              ...gameState.flowers.map((flower) => FlowerWidget(flower: flower)),
              ...gameState.nets.map((net) => NetWidget(net: net)),
              ButterflyWidget(butterfly: gameState.butterfly),
              
              // UI overlay
              _buildUI(),
              
              // Game over overlay
              if (gameState.status == GameStatus.gameOver) _buildGameOverOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: BackgroundPainter(),
      ),
    );
  }

  Widget _buildUI() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Score: ${gameState.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'High Score: ${gameState.highScore}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Over!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Final Score: ${gameState.score}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _resetGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Draw simple cloud shapes
    for (int i = 0; i < 5; i++) {
      final x = (size.width / 5) * i;
      final y = 50 + (i % 2) * 100;
      
      canvas.drawCircle(Offset(x, y), 30, paint);
      canvas.drawCircle(Offset(x + 20, y), 25, paint);
      canvas.drawCircle(Offset(x + 40, y), 30, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 