import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../models/game_state.dart';
import '../models/game_entities.dart';
import 'butterfly_widget.dart';
import 'flower_widget.dart';
import 'golden_flower_widget.dart';
import 'purple_flower_widget.dart';
import 'net_widget.dart';
import 'giant_bird_widget.dart';
import 'bird_widget.dart';

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
  bool isMovingButterfly2Up = false;
  bool isMovingButterfly2Down = false;

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
      if (mounted && gameState.status == GameStatus.playing) {
        setState(() {
          gameState.update();
          
          // Handle continuous movement for bee (Player 1)
          if (isMovingUp) {
            gameState.moveButterflyUp();
          }
          if (isMovingDown) {
            gameState.moveButterflyDown();
          }
          
          // Handle continuous movement for butterfly (Player 2)
          if ((gameState.gameMode == GameMode.twoPlayer || gameState.gameMode == GameMode.teams) && isMovingButterfly2Up) {
            gameState.moveButterfly2Up();
          }
          if ((gameState.gameMode == GameMode.twoPlayer || gameState.gameMode == GameMode.teams) && isMovingButterfly2Down) {
            gameState.moveButterfly2Down();
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
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (gameState.status == GameStatus.playing) {
          setState(() {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                isMovingUp = true;
                isMovingDown = false;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                isMovingUp = false;
                isMovingDown = true;
              } else if ((gameState.gameMode == GameMode.twoPlayer || gameState.gameMode == GameMode.teams) && event.logicalKey == LogicalKeyboardKey.keyW) {
                isMovingButterfly2Up = true;
                isMovingButterfly2Down = false;
              } else if ((gameState.gameMode == GameMode.twoPlayer || gameState.gameMode == GameMode.teams) && event.logicalKey == LogicalKeyboardKey.keyS) {
                isMovingButterfly2Up = false;
                isMovingButterfly2Down = true;
              } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                if (gameState.status == GameStatus.playing) {
                  gameState.pauseGame();
                } else if (gameState.status == GameStatus.paused) {
                  gameState.resumeGame();
                }
              }
            } else if (event is RawKeyUpEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                isMovingUp = false;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                isMovingDown = false;
              } else if (gameState.gameMode == GameMode.twoPlayer && event.logicalKey == LogicalKeyboardKey.keyW) {
                isMovingButterfly2Up = false;
              } else if (gameState.gameMode == GameMode.twoPlayer && event.logicalKey == LogicalKeyboardKey.keyS) {
                isMovingButterfly2Down = false;
              }
            }
          });
        }
      },
      child: GestureDetector(
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
            color: Color(0xFF4A7C59), // Jade green
          ),
          child: Stack(
            children: [
              // Background clouds
              _buildBackground(),
              
              // Game elements
              ...gameState.flowers.map((flower) => FlowerWidget(flower: flower)),
              ...gameState.goldenFlowers.map((goldenFlower) => GoldenFlowerWidget(goldenFlower: goldenFlower)),
              ...gameState.purpleFlowers.map((purpleFlower) => PurpleFlowerWidget(purpleFlower: purpleFlower)),
              ...gameState.nets.map((net) => NetWidget(net: net, hasImmunity: gameState.butterfly.hasImmunity, isFlashing: gameState.isImmunityFlashing)),
              ...gameState.birds.map((bird) => BirdWidget(bird: bird, hasImmunity: gameState.butterfly.hasImmunity, isFlashing: gameState.isImmunityFlashing)),
              ...gameState.giantBirds.map((giantBird) => GiantBirdWidget(giantBird: giantBird, hasImmunity: gameState.butterfly.hasImmunity, isFlashing: gameState.isImmunityFlashing)),
              ButterflyWidget(butterfly: gameState.butterfly, isDead: gameState.isBeeDead),
              if (gameState.gameMode == GameMode.twoPlayer || gameState.gameMode == GameMode.teams) Butterfly2Widget(butterfly2: gameState.butterfly2, isDead: gameState.isButterflyDead),
              
              // UI overlay
              Positioned.fill(
                child: Column(
                  children: [
                    // Pause button at top
                    if (gameState.status == GameStatus.playing)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  gameState.pauseGame();
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Score display below pause button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          if (gameState.gameMode == GameMode.teams) ...[
                            Text(
                              'Team Score: ${gameState.getCombinedScore()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'High Score: ${gameState.getCombinedHighScore()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else ...[
                          Text(
                            'Score: ${gameState.score1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'High Score: ${gameState.gameMode == GameMode.onePlayer ? gameState.highScore1Player : gameState.highScore1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (gameState.gameMode == GameMode.twoPlayer) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Score: ${gameState.score2}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'High Score: ${gameState.highScore2}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          ],
                        ],
                      ),
                    ),
                    
                    // Timer displays
                    if (gameState.getSpeedBoostRemainingSeconds() > 0 || gameState.getImmunityRemainingSeconds() > 0)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (gameState.getSpeedBoostRemainingSeconds() > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '⚡',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Speed: ${gameState.getSpeedBoostRemainingSeconds()}s',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (gameState.getImmunityRemainingSeconds() > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '🛡️',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Immunity: ${gameState.getImmunityRemainingSeconds()}s',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Control buttons at bottom
                    if (gameState.status == GameStatus.playing) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left side - W and S buttons for butterfly (2-player mode and teams mode)
                            if (gameState.gameMode == GameMode.twoPlayer || gameState.gameMode == GameMode.teams) ...[
                              Column(
                                children: [
                                  // Butterfly emoji label
                                  const Text(
                                    '🦋',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // W button
                                      GestureDetector(
                                        onTapDown: (_) {
                                          setState(() {
                                            _isMovingButterfly2Up = true;
                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            _isMovingButterfly2Up = false;
                                          });
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            _isMovingButterfly2Up = false;
                                          });
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.purple.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(40),
                                            border: Border.all(color: Colors.white, width: 3),
                                          ),
                                          child: const Text(
                                            'W',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      // S button
                                      GestureDetector(
                                        onTapDown: (_) {
                                          setState(() {
                                            _isMovingButterfly2Down = true;
                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            _isMovingButterfly2Down = false;
                                          });
                                        },
                                        onTapCancel: () {
                                          setState(() {
                                            _isMovingButterfly2Down = false;
                                          });
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.purple.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(40),
                                            border: Border.all(color: Colors.white, width: 3),
                                          ),
                                          child: const Text(
                                            'S',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20), // Add some padding from the left edge
                                    ],
                                  ),
                                ],
                              ),
                            ],
                            
                            // Right side - Up and Down buttons for bee
                            Column(
                              children: [
                                // Bee emoji label
                                const Text(
                                  '🐝',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  children: [
                                    // Up button
                                    GestureDetector(
                                      onTapDown: (_) {
                                        setState(() {
                                          _isMovingUp = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _isMovingUp = false;
                                        });
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _isMovingUp = false;
                                        });
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(color: Colors.white, width: 3),
                                        ),
                                        child: const Icon(
                                          Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Down button
                                    GestureDetector(
                                      onTapDown: (_) {
                                        setState(() {
                                          _isMovingDown = true;
                                        });
                                      },
                                      onTapUp: (_) {
                                        setState(() {
                                          _isMovingDown = false;
                                        });
                                      },
                                      onTapCancel: () {
                                        setState(() {
                                          _isMovingDown = false;
                                        });
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(40),
                                          border: Border.all(color: Colors.white, width: 3),
                                        ),
                                        child: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Game over overlay
              if (gameState.status == GameStatus.gameOver) _buildGameOverOverlay(),
              
              // Pause overlay
              if (gameState.status == GameStatus.paused) _buildPauseOverlay(),
              
              // Menu overlay
              if (gameState.status == GameStatus.menu) _buildMenuOverlay(),
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
    return Column(
      children: [
        // Score display
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Score: ${gameState.score1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'High Score: ${gameState.gameMode == GameMode.onePlayer ? gameState.highScore1Player : gameState.highScore1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (gameState.gameMode == GameMode.twoPlayer) ...[
                const SizedBox(height: 8),
                Text(
                  'Score: ${gameState.score2}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'High Score: ${gameState.highScore2}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        // Control buttons
        if (gameState.status == GameStatus.playing) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Up button
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isMovingUp = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isMovingUp = false;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _isMovingUp = false;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Down button
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isMovingDown = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isMovingDown = false;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      _isMovingDown = false;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
              if (gameState.gameMode == GameMode.teams) ...[
                Text(
                  '🏆 Team Score: ${gameState.getCombinedScore()}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
              Text(
                '🐝 Bee Score: ${gameState.score1}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (gameState.gameMode == GameMode.twoPlayer) ...[
                const SizedBox(height: 8),
                Text(
                  '🦋 Butterfly Score: ${gameState.score2}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ],
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameState.returnToMenu();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Back to Menu',
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

  Widget _buildPauseOverlay() {
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
                'Game Paused',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameState.resumeGame();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text(
                  'Resume',
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

  Widget _buildMenuOverlay() {
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
                'Select Game Mode',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameState.selectOnePlayer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      '1 Player',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Use up and down buttons on the keyboard to control bee',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameState.selectTwoPlayer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      '2 Players',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Use up and down buttons on the keyboard to control bee and Use W and S buttons on the keyboard to control butterfly',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameState.selectTeams();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'Teams',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Both bee and butterfly work together with combined score',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
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
    // Draw some clouds
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 3; i++) {
      final x = (size.width / 4) * i;
      final y = 50 + (i % 2) * 80;
      
      canvas.drawCircle(Offset(x, y), 25, cloudPaint);
      canvas.drawCircle(Offset(x + 15, y), 20, cloudPaint);
      canvas.drawCircle(Offset(x + 30, y), 25, cloudPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 