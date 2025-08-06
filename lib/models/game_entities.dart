import 'dart:math';

class Butterfly {
  double x;
  double y;
  double width;
  double height;
  double speed;
  double baseSpeed;
  bool hasSpeedBoost;
  bool isSlowed;
  bool hasImmunity;
  DateTime? speedBoostEndTime;
  DateTime? slowEndTime;
  DateTime? immunityEndTime;
  
  Butterfly({
    required this.x,
    required this.y,
    this.width = 32,
    this.height = 32,
    this.speed = 7,
  }) : baseSpeed = 7,
       hasSpeedBoost = false,
       isSlowed = false,
       hasImmunity = false,
       speedBoostEndTime = null,
       slowEndTime = null,
       immunityEndTime = null;
  
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
  
  void activateSpeedBoost() {
    hasSpeedBoost = true;
    speed = baseSpeed * 2; // Double speed (14)
    speedBoostEndTime = DateTime.now().add(Duration(seconds: 10)); // 10 second duration
  }
  
  void activateSlowEffect() {
    if (!hasImmunity) {
      isSlowed = true;
      speed = baseSpeed * 0.5; // Half speed (3.5)
      slowEndTime = DateTime.now().add(Duration(seconds: 3)); // 3 second duration
    }
  }
  
  void activateImmunity() {
    hasImmunity = true;
    immunityEndTime = DateTime.now().add(Duration(seconds: 15)); // 15 second immunity
  }
  
  void updateSpeedEffects() {
    // Update speed boost
    if (hasSpeedBoost && speedBoostEndTime != null) {
      if (DateTime.now().isAfter(speedBoostEndTime!)) {
        hasSpeedBoost = false;
        speedBoostEndTime = null;
        // Reset to base speed or slow speed
        if (isSlowed) {
          speed = baseSpeed * 0.5;
        } else {
          speed = baseSpeed;
        }
      }
    }
    
    // Update slow effect
    if (isSlowed && slowEndTime != null) {
      if (DateTime.now().isAfter(slowEndTime!)) {
        isSlowed = false;
        slowEndTime = null;
        // Reset to base speed or boosted speed
        if (hasSpeedBoost) {
          speed = baseSpeed * 2;
        } else {
          speed = baseSpeed;
        }
      }
    }
    
    // Update immunity
    if (hasImmunity && immunityEndTime != null) {
      if (DateTime.now().isAfter(immunityEndTime!)) {
        hasImmunity = false;
        immunityEndTime = null;
      }
    }
  }
  
  void resetSpeed() {
    hasSpeedBoost = false;
    isSlowed = false;
    hasImmunity = false;
    speed = baseSpeed;
    speedBoostEndTime = null;
    slowEndTime = null;
    immunityEndTime = null;
  }
  
  Rect get bounds => Rect.fromLTWH(x, y, width, height);
}

class Butterfly2 {
  double x;
  double y;
  double width;
  double height;
  double speed;
  double baseSpeed;
  bool hasSpeedBoost;
  bool isSlowed;
  bool hasImmunity;
  DateTime? speedBoostEndTime;
  DateTime? slowEndTime;
  DateTime? immunityEndTime;
  
  Butterfly2({
    required this.x,
    required this.y,
    this.width = 32,
    this.height = 32,
    this.speed = 7,
  }) : baseSpeed = 7,
       hasSpeedBoost = false,
       isSlowed = false,
       hasImmunity = false,
       speedBoostEndTime = null,
       slowEndTime = null,
       immunityEndTime = null;
  
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
  
  void activateSpeedBoost() {
    hasSpeedBoost = true;
    speed = baseSpeed * 2; // Double speed (14)
    speedBoostEndTime = DateTime.now().add(Duration(seconds: 10)); // 10 second duration
  }
  
  void activateSlowEffect() {
    if (!hasImmunity) {
      isSlowed = true;
      speed = baseSpeed * 0.5; // Half speed (3.5)
      slowEndTime = DateTime.now().add(Duration(seconds: 3)); // 3 second duration
    }
  }
  
  void activateImmunity() {
    hasImmunity = true;
    immunityEndTime = DateTime.now().add(Duration(seconds: 15)); // 15 second immunity
  }
  
  void updateSpeedEffects() {
    // Update speed boost
    if (hasSpeedBoost && speedBoostEndTime != null) {
      if (DateTime.now().isAfter(speedBoostEndTime!)) {
        hasSpeedBoost = false;
        speedBoostEndTime = null;
        // Reset to base speed or slow speed
        if (isSlowed) {
          speed = baseSpeed * 0.5;
        } else {
          speed = baseSpeed;
        }
      }
    }
    
    // Update slow effect
    if (isSlowed && slowEndTime != null) {
      if (DateTime.now().isAfter(slowEndTime!)) {
        isSlowed = false;
        slowEndTime = null;
        // Reset to base speed or boosted speed
        if (hasSpeedBoost) {
          speed = baseSpeed * 2;
        } else {
          speed = baseSpeed;
        }
      }
    }
    
    // Update immunity
    if (hasImmunity && immunityEndTime != null) {
      if (DateTime.now().isAfter(immunityEndTime!)) {
        hasImmunity = false;
        immunityEndTime = null;
      }
    }
  }
  
  void resetSpeed() {
    speed = baseSpeed;
    hasSpeedBoost = false;
    isSlowed = false;
    hasImmunity = false;
    speedBoostEndTime = null;
    slowEndTime = null;
    immunityEndTime = null;
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
    this.width = 24,
    this.height = 24,
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

class GoldenFlower {
  double x;
  double y;
  double width;
  double height;
  double speed;
  bool isCollected;
  
  GoldenFlower({
    required this.x,
    required this.y,
    this.width = 24,
    this.height = 24,
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
  bool isCollected;
  
  Net({
    required this.x,
    required this.y,
    this.width = 32,
    this.height = 32,
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

class PurpleFlower {
  double x;
  double y;
  double width;
  double height;
  double speed;
  bool isCollected;
  
  PurpleFlower({
    required this.x,
    required this.y,
    this.width = 24,
    this.height = 24,
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

class GiantBird {
  double x;
  double y;
  double width;
  double height;
  double speed;
  double targetY;
  double targetX;
  bool isAttracted;
  double attractionSpeed;
  DateTime? passedTime;
  
  GiantBird({
    required this.x,
    required this.y,
    this.width = 64,
    this.height = 64,
    this.speed = 4,
  }) : targetY = y,
       targetX = x,
       isAttracted = false,
       attractionSpeed = 5,
       passedTime = null;
  
  void update(double butterflyY, double butterflyX) {
    // Move from right to left (from front to back)
    x -= speed;
    
    // Move towards butterfly's Y position
    if (y < butterflyY) {
      y += speed * 0.5; // Move down
    } else if (y > butterflyY) {
      y -= speed * 0.5; // Move up
    }
  }
  
  bool isOffScreen() {
    return x + width < 0; // Off screen to the left
  }
  
  Rect get bounds => Rect.fromLTWH(x, y, width, height);
}

class Bird {
  double x;
  double y;
  double width;
  double height;
  double speed;
  bool isGiantBird; // Visual type for some birds to appear as giant birds
  
  Bird({
    required this.x,
    required this.y,
    this.width = 32,
    this.height = 32,
    this.speed = 3,
    this.isGiantBird = false,
  });
  
  void update() {
    x -= speed;
  }
  
  bool isOffScreen() {
    return x + width < 0;
  }
  
  Rect get bounds {
    if (isGiantBird) {
      // Smaller hitbox for giant birds (12px inset)
      return Rect.fromLTWH(x + 12, y + 12, width - 24, height - 24);
    } else {
      // Smaller hitbox for regular birds (12px inset)
      return Rect.fromLTWH(x + 12, y + 12, width - 24, height - 24);
    }
  }
} 