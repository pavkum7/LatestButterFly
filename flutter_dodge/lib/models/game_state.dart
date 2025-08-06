import 'dart:math';
import 'game_entities.dart';

enum GameStatus { playing, gameOver, paused }

class GameState {
  Butterfly butterfly;
  List<Flower> flowers;
  List<Net> nets;
  GameStatus status;
  int score;
  int highScore;
  double screenWidth;
  double screenHeight;
  Random random;
  
  GameState({
    required this.screenWidth,
    required this.screenHeight,
  }) : butterfly = Butterfly(
          x: 100,
          y: screenHeight / 2 - 20,
        ),
        flowers = [],
        nets = [],
        status = GameStatus.playing,
        score = 0,
        highScore = 0,
        random = Random();
  
  void update() {
    if (status != GameStatus.playing) return;
    
    // Update butterfly position (handled by input)
    
    // Update flowers
    for (var flower in flowers) {
      flower.update();
    }
    flowers.removeWhere((flower) => flower.isOffScreen());
    
    // Update nets
    for (var net in nets) {
      net.update();
    }
    nets.removeWhere((net) => net.isOffScreen());
    
    // Spawn new flowers (one per frame)
    if (random.nextDouble() < 0.1) { // 10% chance per frame
      spawnFlower();
    }
    
    // Spawn new nets
    if (random.nextDouble() < 0.05) { // 5% chance per frame
      spawnNet();
    }
    
    // Check collisions
    checkCollisions();
  }
  
  void spawnFlower() {
    double y = random.nextDouble() * (screenHeight - 30);
    flowers.add(Flower(
      x: screenWidth,
      y: y,
    ));
  }
  
  void spawnNet() {
    double y = random.nextDouble() * (screenHeight - 50);
    nets.add(Net(
      x: screenWidth,
      y: y,
    ));
  }
  
  void checkCollisions() {
    // Check flower collisions
    for (var flower in flowers) {
      if (!flower.isCollected && butterfly.bounds.overlaps(flower.bounds)) {
        flower.isCollected = true;
        score += 10;
        if (score > highScore) {
          highScore = score;
        }
      }
    }
    
    // Check net collisions
    for (var net in nets) {
      if (butterfly.bounds.overlaps(net.bounds)) {
        gameOver();
      }
    }
  }
  
  void gameOver() {
    status = GameStatus.gameOver;
  }
  
  void reset() {
    butterfly = Butterfly(
      x: 100,
      y: screenHeight / 2 - 20,
    );
    flowers.clear();
    nets.clear();
    status = GameStatus.playing;
    score = 0;
  }
  
  void moveButterflyUp() {
    if (status == GameStatus.playing) {
      butterfly.moveUp(screenHeight);
    }
  }
  
  void moveButterflyDown() {
    if (status == GameStatus.playing) {
      butterfly.moveDown(screenHeight);
    }
  }
} 