import 'dart:math';
import 'game_entities.dart';

enum GameStatus { playing, gameOver, paused, menu }
enum GameMode { onePlayer, twoPlayer, teams }

class GameState {
  Butterfly butterfly;
  Butterfly2 butterfly2;
  List<Flower> flowers;
  List<GoldenFlower> goldenFlowers;
  List<PurpleFlower> purpleFlowers = [];
  List<Bird> birds;
  List<Net> nets;
  List<GiantBird> giantBirds;
  GameStatus status;
  GameMode gameMode;
  int score1; // Bee score
  int score2; // Butterfly score
  int highScore1; // Bee high score
  int highScore2; // Butterfly high score
  int highScore1Player; // 1-player mode high score
  int highScore2Player; // 2-player mode high score
  int highScoreTeams; // Teams mode high score
  int flowersCollected1; // Bee flowers collected
  int flowersCollected2; // Butterfly flowers collected
  bool isBeeDead;
  bool isButterflyDead;
  double screenWidth;
  double screenHeight;
  bool isGlobalSlow;
  DateTime? globalSlowEndTime;
  bool isGlobalSpeed;
  DateTime? globalSpeedEndTime;
  bool isImmunityFlashing;
  DateTime? speedBoostEndTime;
  DateTime? immunityEndTime;
  Random random;
  
  GameState({
    required this.screenWidth,
    required this.screenHeight,
  }) : butterfly = Butterfly(x: 100, y: 300),
       butterfly2 = Butterfly2(x: 100, y: 300),
       flowers = [],
       goldenFlowers = [],
       purpleFlowers = [],
       birds = [],
       nets = [],
       giantBirds = [],
       score1 = 0,
       score2 = 0,
       highScore1 = 0,
       highScore2 = 0,
       highScore1Player = 0,
       highScore2Player = 0,
       highScoreTeams = 0,
       flowersCollected1 = 0,
       flowersCollected2 = 0,
       isBeeDead = false,
       isButterflyDead = false,
       status = GameStatus.menu,
       gameMode = GameMode.twoPlayer,
       isGlobalSlow = false,
       globalSlowEndTime = null,
       isGlobalSpeed = false,
       globalSpeedEndTime = null,
       isImmunityFlashing = false,
       speedBoostEndTime = null,
       immunityEndTime = null,
       random = Random();
  
  void update() {
    if (status != GameStatus.playing) return;
    
    // Update global slow effect
    updateGlobalSlow();
    
    // Update global speed effect
    updateGlobalSpeed();
    
    // Update immunity flashing effect
    if (butterfly.hasImmunity && butterfly.immunityEndTime != null) {
      final remainingSeconds = butterfly.immunityEndTime!.difference(DateTime.now()).inSeconds;
      isImmunityFlashing = remainingSeconds <= 5 && remainingSeconds > 0;
    } else {
      isImmunityFlashing = false;
    }
    
    // Update butterfly speed effects
    butterfly.updateSpeedEffects();
    butterfly2.updateSpeedEffects();
    
    // Update butterfly position (handled by input)
    
    // Update flowers
    for (var flower in flowers) {
      flower.update();
    }
    flowers.removeWhere((flower) => flower.isOffScreen());
    
    // Update golden flowers
    for (var goldenFlower in goldenFlowers) {
      goldenFlower.update();
    }
    goldenFlowers.removeWhere((goldenFlower) => goldenFlower.isOffScreen());
    
    // Update purple flowers
    for (var purpleFlower in purpleFlowers) {
      purpleFlower.update();
    }
    purpleFlowers.removeWhere((purpleFlower) => purpleFlower.isOffScreen());
    
    // Update birds
    for (var bird in birds) {
      bird.update();
    }
    birds.removeWhere((bird) => bird.isOffScreen());
    
    // Update nets
    for (var net in nets) {
      net.update();
    }
    nets.removeWhere((net) => net.isOffScreen());
    
    // Update giant birds (chasing from behind)
    for (var giantBird in giantBirds) {
      giantBird.update(butterfly.y, butterfly.x);
    }
    giantBirds.removeWhere((giantBird) => giantBird.isOffScreen());
    
    // Spawn new flowers (max 5 per screen)
    if (flowers.length < 5 && random.nextDouble() < 0.09) { // 9% chance per screen, max 5 flowers
      spawnFlower();
    }

    // Spawn new birds (max 15 per screen)
    if (birds.length < 15 && random.nextDouble() < 0.10) { // 10% chance per screen, max 15 birds
      spawnBird();
    }
    
    // Spawn new nets (very rare)
    if (nets.length < 2 && random.nextDouble() < 0.02) { // 2% chance per screen, max 2 nets
      spawnNet();
    }
    
    // Check collisions
    checkCollisions();
  }
  
  void updateGlobalSlow() {
    if (isGlobalSlow && globalSlowEndTime != null) {
      if (DateTime.now().isAfter(globalSlowEndTime!)) {
        isGlobalSlow = false;
        globalSlowEndTime = null;
        // Reset all entity speeds to normal
        resetAllSpeeds();
      }
    }
  }
  
  void updateGlobalSpeed() {
    if (isGlobalSpeed && globalSpeedEndTime != null) {
      if (DateTime.now().isAfter(globalSpeedEndTime!)) {
        isGlobalSpeed = false;
        globalSpeedEndTime = null;
        // Reset all entity speeds to normal
        resetAllSpeeds();
      }
    }
  }
  
  void activateGlobalSlow() {
    isGlobalSlow = true;
    globalSlowEndTime = DateTime.now().add(Duration(seconds: 3)); // 3 second global slow
    // Slow down all entities
    slowAllEntities();
  }
  
  void activateGlobalSpeed() {
    isGlobalSpeed = true;
    globalSpeedEndTime = DateTime.now().add(Duration(seconds: 5)); // 5 second global speed
    // Speed up all entities except butterflies
    speedUpAllEntities();
  }
  
  void slowAllEntities() {
    // Slow down flowers
    for (var flower in flowers) {
      flower.speed = 1.5; // Half speed
    }
    
    // Slow down golden flowers
    for (var goldenFlower in goldenFlowers) {
      goldenFlower.speed = 1.5;
    }
    
    // Slow down purple flowers
    for (var purpleFlower in purpleFlowers) {
      purpleFlower.speed = 1.5;
    }
    
    // Slow down birds
    for (var bird in birds) {
      bird.speed = 1.5;
    }
    
    // Slow down nets
    for (var net in nets) {
      net.speed = 1.5;
    }
    
    // Giant birds are immune to global slow effect
    // They maintain their normal speed
  }
  
  void speedUpAllEntities() {
    // Speed up flowers
    for (var flower in flowers) {
      flower.speed = 6; // Double speed
    }
    
    // Speed up golden flowers
    for (var goldenFlower in goldenFlowers) {
      goldenFlower.speed = 6;
    }
    
    // Speed up purple flowers
    for (var purpleFlower in purpleFlowers) {
      purpleFlower.speed = 6;
    }
    
    // Speed up birds
    for (var bird in birds) {
      bird.speed = 6;
    }
    
    // Speed up nets
    for (var net in nets) {
      net.speed = 6;
    }
    
    // Speed up giant birds
    for (var giantBird in giantBirds) {
      giantBird.speed = 8;
    }
  }
  
  void resetAllSpeeds() {
    // Reset flower speeds
    for (var flower in flowers) {
      flower.speed = 3;
    }
    
    // Reset golden flower speeds
    for (var goldenFlower in goldenFlowers) {
      goldenFlower.speed = 3;
    }
    
    // Reset purple flower speeds
    for (var purpleFlower in purpleFlowers) {
      purpleFlower.speed = 3;
    }
    
    // Reset bird speeds
    for (var bird in birds) {
      bird.speed = 3;
    }
    
    // Reset net speeds
    for (var net in nets) {
      net.speed = 3;
    }
    
    // Reset giant bird speeds
    for (var giantBird in giantBirds) {
      giantBird.speed = 4;
    }
  }
  
  void spawnFlower() {
    double y = random.nextDouble() * (screenHeight - 30);
    double speed;
    if (isGlobalSlow) {
      speed = 1.5; // Slow speed if global slow is active
    } else if (isGlobalSpeed) {
      speed = 6.0; // Fast speed if global speed is active
    } else {
      speed = 3.0; // Normal speed
    }
    flowers.add(Flower(
      x: screenWidth,
      y: y,
      speed: speed,
    ));
  }
  
  void spawnGoldenFlower() {
    double y = random.nextDouble() * (screenHeight - 30);
    double speed;
    if (isGlobalSlow) {
      speed = 1.5; // Slow speed if global slow is active
    } else if (isGlobalSpeed) {
      speed = 6.0; // Fast speed if global speed is active
    } else {
      speed = 3.0; // Normal speed
    }
    goldenFlowers.add(GoldenFlower(
      x: screenWidth,
      y: y,
      speed: speed,
    ));
  }
  
  void spawnPurpleFlower() {
    double y = random.nextDouble() * (screenHeight - 30);
    double speed;
    if (isGlobalSlow) {
      speed = 1.5; // Slow speed if global slow is active
    } else if (isGlobalSpeed) {
      speed = 6.0; // Fast speed if global speed is active
    } else {
      speed = 3.0; // Normal speed
    }
    purpleFlowers.add(PurpleFlower(
      x: screenWidth,
      y: y,
      speed: speed,
    ));
  }
  
  void spawnNet() {
    double y = random.nextDouble() * (screenHeight - 32);
    double speed;
    if (isGlobalSlow) {
      speed = 1.5; // Slow speed if global slow is active
    } else if (isGlobalSpeed) {
      speed = 6.0; // Fast speed if global speed is active
    } else {
      speed = 3.0; // Normal speed
    }
    nets.add(Net(
      x: screenWidth,
      y: y,
      speed: speed,
    ));
  }
  
  void spawnGiantBird() {
    double y = random.nextDouble() * (screenHeight - 64);
    double speed;
    if (isGlobalSlow) {
      speed = 2.0; // Slow speed if global slow is active
    } else if (isGlobalSpeed) {
      speed = 8.0; // Fast speed if global speed is active
    } else {
      speed = 4.0; // Normal speed
    }
    giantBirds.add(GiantBird(
      x: screenWidth, // Start from the front (right side) of the screen
      y: y,
      speed: speed,
    ));
  }
  
  void spawnBird() {
    double y = random.nextDouble() * (screenHeight - 40);
    double speed;
    if (isGlobalSlow) {
      speed = 1.5; // Slow speed if global slow is active
    } else if (isGlobalSpeed) {
      speed = 6.0; // Fast speed if global speed is active
    } else {
      speed = 3.0; // Normal speed
    }
    bool isGiantBird = random.nextDouble() < 0.3; // 30% chance to be a giant bird
    birds.add(Bird(
      x: screenWidth,
      y: y,
      speed: speed,
      isGiantBird: isGiantBird,
    ));
  }
  
  void checkCollisions() {
    // Check flower collisions for both butterflies
    for (var flower in flowers) {
      if (!flower.isCollected) {
        if (!isBeeDead && butterfly.bounds.overlaps(flower.bounds)) {
          flower.isCollected = true;
          score1 += 1;
          flowersCollected1 += 1;
          if (gameMode == GameMode.onePlayer) {
            if (score1 > highScore1Player) {
              highScore1Player = score1;
            }
          } else if (gameMode == GameMode.teams) {
            if (getCombinedScore() > highScoreTeams) {
              highScoreTeams = getCombinedScore();
            }
          } else {
            if (score1 > highScore1) {
              highScore1 = score1;
            }
          }
          
          // Check if we should spawn a golden flower (every 15 points)
          if (score1 % 15 == 0) {
            spawnGoldenFlower();
          }
          
          // Check if we should spawn a giant bird (every 50 flowers collected)
          if (flowersCollected1 % 50 == 0 && flowersCollected1 > 0) {
            spawnGiantBird();
          }
          
          // Check if we should spawn a purple flower (every 25 flowers collected)
          if (flowersCollected1 % 25 == 0 && flowersCollected1 > 0) {
            spawnPurpleFlower();
          }
        } else if (!isButterflyDead && butterfly2.bounds.overlaps(flower.bounds)) {
          flower.isCollected = true;
          score2 += 1;
          flowersCollected2 += 1;
          if (gameMode == GameMode.onePlayer) {
            if (score2 > highScore2Player) {
              highScore2Player = score2;
            }
          } else if (gameMode == GameMode.teams) {
            if (getCombinedScore() > highScoreTeams) {
              highScoreTeams = getCombinedScore();
            }
          } else {
            if (score2 > highScore2) {
              highScore2 = score2;
            }
          }
          
          // Check if we should spawn a golden flower (every 15 points)
          if (score2 % 15 == 0) {
            spawnGoldenFlower();
          }
          
          // Check if we should spawn a giant bird (every 50 flowers collected)
          if (flowersCollected2 % 50 == 0 && flowersCollected2 > 0) {
            spawnGiantBird();
          }
          
          // Check if we should spawn a purple flower (every 25 flowers collected)
          if (flowersCollected2 % 25 == 0 && flowersCollected2 > 0) {
            spawnPurpleFlower();
          }
        }
      }
    }
    
    // Check golden flower collisions for both butterflies
    for (var goldenFlower in goldenFlowers) {
      if (!goldenFlower.isCollected) {
        if (!isBeeDead && butterfly.bounds.overlaps(goldenFlower.bounds)) {
          goldenFlower.isCollected = true;
          score1 += 3; // Golden flowers worth 3 points
          if (gameMode == GameMode.onePlayer) {
            if (score1 > highScore1Player) {
              highScore1Player = score1;
            }
          } else if (gameMode == GameMode.teams) {
            if (getCombinedScore() > highScoreTeams) {
              highScoreTeams = getCombinedScore();
            }
          } else {
            if (score1 > highScore1) {
              highScore1 = score1;
            }
          }
          activateGlobalSpeed(); // Activate 5-second global speed boost
          speedBoostEndTime = DateTime.now().add(Duration(seconds: 10)); // 10-second countdown
        } else if (!isButterflyDead && butterfly2.bounds.overlaps(goldenFlower.bounds)) {
          goldenFlower.isCollected = true;
          score2 += 3; // Golden flowers worth 3 points
          if (gameMode == GameMode.onePlayer) {
            if (score2 > highScore2Player) {
              highScore2Player = score2;
            }
          } else if (gameMode == GameMode.teams) {
            if (getCombinedScore() > highScoreTeams) {
              highScoreTeams = getCombinedScore();
            }
          } else {
            if (score2 > highScore2) {
              highScore2 = score2;
            }
          }
          activateGlobalSpeed(); // Activate 5-second global speed boost
          speedBoostEndTime = DateTime.now().add(Duration(seconds: 10)); // 10-second countdown
        }
      }
    }
    
    // Check purple flower collisions for both butterflies
    for (var purpleFlower in purpleFlowers) {
      if (!purpleFlower.isCollected) {
        if (!isBeeDead && butterfly.bounds.overlaps(purpleFlower.bounds)) {
          purpleFlower.isCollected = true;
          score1 += 5; // Purple flowers worth 5 points
          if (gameMode == GameMode.onePlayer) {
            if (score1 > highScore1Player) {
              highScore1Player = score1;
            }
          } else if (gameMode == GameMode.teams) {
            if (getCombinedScore() > highScoreTeams) {
              highScoreTeams = getCombinedScore();
            }
          } else {
            if (score1 > highScore1) {
              highScore1 = score1;
            }
          }
          butterfly.activateImmunity(); // Activate 15-second immunity
          immunityEndTime = DateTime.now().add(Duration(seconds: 15)); // 15-second countdown
        } else if (!isButterflyDead && butterfly2.bounds.overlaps(purpleFlower.bounds)) {
          purpleFlower.isCollected = true;
          score2 += 5; // Purple flowers worth 5 points
          if (gameMode == GameMode.onePlayer) {
            if (score2 > highScore2Player) {
              highScore2Player = score2;
            }
          } else if (gameMode == GameMode.teams) {
            if (getCombinedScore() > highScoreTeams) {
              highScoreTeams = getCombinedScore();
            }
          } else {
            if (score2 > highScore2) {
              highScore2 = score2;
            }
          }
          butterfly2.activateImmunity(); // Activate 15-second immunity
          immunityEndTime = DateTime.now().add(Duration(seconds: 15)); // 15-second countdown
        }
      }
    }
    
    // Check net collisions for both butterflies
    for (var net in nets) {
      if (!net.isCollected) {
        if (!isBeeDead && !butterfly.hasImmunity && butterfly.bounds.overlaps(net.bounds)) {
          net.isCollected = true;
          activateGlobalSlow(); // Activate 3-second global slow effect
        } else if (!isButterflyDead && !butterfly2.hasImmunity && butterfly2.bounds.overlaps(net.bounds)) {
          net.isCollected = true;
          activateGlobalSlow(); // Activate 3-second global slow effect
        }
      }
    }
    
    // Check bird collisions for both butterflies
    for (var bird in birds) {
      if (!butterfly.hasImmunity && butterfly.bounds.overlaps(bird.bounds) && !isBeeDead) {
        isBeeDead = true;
        checkGameOver();
      }
      if (!butterfly2.hasImmunity && butterfly2.bounds.overlaps(bird.bounds) && !isButterflyDead) {
        isButterflyDead = true;
        checkGameOver();
      }
    }
    
    // Check giant bird collisions for both butterflies
    for (var giantBird in giantBirds) {
      if (!butterfly.hasImmunity && butterfly.bounds.overlaps(giantBird.bounds) && !isBeeDead) {
        isBeeDead = true;
        checkGameOver();
      }
      if (!butterfly2.hasImmunity && butterfly2.bounds.overlaps(giantBird.bounds) && !isButterflyDead) {
        isButterflyDead = true;
        checkGameOver();
      }
    }
  }
  
  void checkGameOver() {
    // Game over logic depends on game mode
    if (gameMode == GameMode.onePlayer) {
      // In 1-player mode, game over when bee dies
      if (isBeeDead) {
        status = GameStatus.gameOver;
      }
    } else if (gameMode == GameMode.teams) {
      // In teams mode, game over when both characters are dead
      if (isBeeDead && isButterflyDead) {
        status = GameStatus.gameOver;
      }
    } else {
      // In 2-player mode, game over only when both characters are dead
      if (isBeeDead && isButterflyDead) {
        status = GameStatus.gameOver;
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
    butterfly2 = Butterfly2(
      x: 100,
      y: screenHeight / 2 - 20,
    );
    flowers.clear();
    goldenFlowers.clear();
    purpleFlowers.clear();
    birds.clear();
    nets.clear();
    giantBirds.clear();
    score1 = 0;
    score2 = 0;
    flowersCollected1 = 0;
    flowersCollected2 = 0;
    isBeeDead = false;
    isButterflyDead = false;
    status = GameStatus.playing;
    isGlobalSlow = false;
    globalSlowEndTime = null;
    isGlobalSpeed = false;
    globalSpeedEndTime = null;
    isImmunityFlashing = false;
    speedBoostEndTime = null;
    immunityEndTime = null;
  }
  
  void moveButterflyUp() {
    butterfly.moveUp(screenHeight);
  }
  
  void moveButterflyDown() {
    butterfly.moveDown(screenHeight);
  }
  
  void moveButterfly2Up() {
    butterfly2.moveUp(screenHeight);
  }
  
  void moveButterfly2Down() {
    butterfly2.moveDown(screenHeight);
  }

  void selectOnePlayer() {
    gameMode = GameMode.onePlayer;
    status = GameStatus.playing;
    reset();
  }
  
  void selectTwoPlayer() {
    gameMode = GameMode.twoPlayer;
    status = GameStatus.playing;
    reset();
  }
  
  void selectTeams() {
    gameMode = GameMode.teams;
    status = GameStatus.playing;
    reset();
  }
  
  void returnToMenu() {
    status = GameStatus.menu;
  }
  
  void pauseGame() {
    if (status == GameStatus.playing) {
      status = GameStatus.paused;
    }
  }
  
  void resumeGame() {
    if (status == GameStatus.paused) {
      status = GameStatus.playing;
    }
  }
  
  int getSpeedBoostRemainingSeconds() {
    if (speedBoostEndTime == null) return 0;
    final remaining = speedBoostEndTime!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }
  
  int getImmunityRemainingSeconds() {
    if (immunityEndTime == null) return 0;
    final remaining = immunityEndTime!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }
  
  int getCombinedScore() {
    return score1 + score2;
  }
  
  int getCombinedHighScore() {
    return highScoreTeams;
  }
} 