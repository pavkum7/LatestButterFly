import 'dart:math';

class Butterfly {
  double x;
  double y;
  double width;
  double height;
  double speed;
  
  Butterfly({
    required this.x,
    required this.y,
    this.width = 40,
    this.height = 40,
    this.speed = 5,
  });
  
  void moveUp(double screenHeight) {
    if (y > 0) {
      y -= speed;
    }
  }
  
  void moveDown(double screenHeight) {
    if (y < screenHeight - height) {
      y += speed;
    }
  }
  
  Rect get bounds => Rect.fromLTWH(x, y, width, height);
}

class Flower {
  double x;
  double y;
  double width;
  double height;
  double speed;
  bool isCollected;
  
  Flower({
    required this.x,
    required this.y,
    this.width = 30,
    this.height = 30,
    this.speed = 3,
    this.isCollected = false,
  });
  
  void update() {
    x -= speed;
  }
  
  bool isOffScreen() {
    return x + width < 0;
  }
  
  Rect get bounds => Rect.fromLTWH(x, y, width, height);
}

class Net {
  double x;
  double y;
  double width;
  double height;
  double speed;
  
  Net({
    required this.x,
    required this.y,
    this.width = 50,
    this.height = 50,
    this.speed = 3,
  });
  
  void update() {
    x -= speed;
  }
  
  bool isOffScreen() {
    return x + width < 0;
  }
  
  Rect get bounds => Rect.fromLTWH(x, y, width, height);
} 