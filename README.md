# Butterfly Dodge Game

A fun arcade-style endless dodger game where you control butterflies collecting flowers while avoiding obstacles!

## 🎮 Game Modes

### **📋 Menu System**
- **Game Mode Selection**: Choose between 1-player and 2-player modes
- **1 Player Mode**: Only the bee (🐝) appears and is controllable
- **2 Player Mode**: Both bee (🐝) and butterfly (🦋) appear and are controllable

### **🎯 1-Player Mode**
- **Single Character**: Only the bee is visible and controllable
- **Keyboard Controls**: 
  - **Up Arrow**: Move bee up
  - **Down Arrow**: Move bee down
- **Single Score**: Only the bee's score is tracked and displayed
- **Game Over**: Game ends when the bee dies

### **👥 2-Player Mode**
- **Dual Characters**: Both bee and butterfly are visible and controllable
- **Separate Keyboard Controls**: 
  - **Bee (🐝)**: Arrow keys (Up/Down)
  - **Butterfly (🦋)**: W/S keys
- **Individual Scoring**: Each character has their own score and high score
- **Individual Survival**: Game continues until both characters die
- **Visual Death State**: Dead characters appear semi-transparent

### **Game Elements**
- **🌸 Flowers**: Collect for 1 point each
- **🌻 Golden Flowers**: Collect for 3 points and 10-second speed boost
- **💜 Purple Flowers**: Collect for 5 points and 15-second immunity
- **🐦 Birds**: Avoid these obstacles (regular birds)
- **🦅 Giant Birds**: Special birds that appear every 50 flowers collected
- **🕸️ Cobwebs**: Slow down all entities for 3 seconds when hit

### **Special Mechanics**
- **Speed Boost**: Golden flowers make you twice as fast for 10 seconds
- **Immunity**: Purple flowers make you immune to all threats for 15 seconds
- **Global Slow**: Cobwebs slow down all game entities for 3 seconds
- **Giant Birds**: Appear every 50 flowers collected, come from the front
- **Visual Effects**: Threats become semi-transparent when you have immunity
- **Flashing Warning**: Immunity opacity flashes during last 5 seconds

## 🎯 How to Play

### **Controls**
- **Arrow Keys**: Control the bee (Player 1)
- **W/S Keys**: Control the butterfly (Player 2)
- **Mouse/Touch**: Drag to move (affects Player 1)

### **Objective**
- Collect as many flowers as possible
- Avoid birds, cobwebs, and giant birds
- Survive as long as possible
- Both players contribute to the same score!

### **Scoring**
- **🐝 Bee Score**: Tracks points collected by the bee (Player 1)
- **🦋 Butterfly Score**: Tracks points collected by the butterfly (Player 2)
- **Regular Flowers**: 1 point each
- **Golden Flowers**: 3 points each + speed boost
- **Purple Flowers**: 5 points each + immunity
- **Individual High Scores**: Each character maintains their own high score

## 🚀 How to Run

### **Flutter Version**
```bash
cd flutter_dodge
flutter run
```

### **Web Version**
```bash
cd web
python3 run_web_server.py
```
Then open `http://localhost:8000` in your browser.

## 📁 Project Structure

```
flutter_dodge/
├── lib/
│   ├── models/
│   │   ├── game_entities.dart
│   │   └── game_state.dart
│   ├── widgets/
│   │   ├── butterfly_widget.dart
│   │   ├── flower_widget.dart
│   │   ├── bird_widget.dart
│   │   ├── net_widget.dart
│   │   ├── golden_flower_widget.dart
│   │   ├── purple_flower_widget.dart
│   │   ├── giant_bird_widget.dart
│   │   └── game_screen.dart
│   └── main.dart
├── web/
│   └── index.html
├── pubspec.yaml
├── README.md
└── run_web_server.py
```

## 🎨 Visual Design

- **Background**: Jade green (#4A7C59)
- **Bee**: 🐝 emoji with rotation based on movement
- **Butterfly**: 🦋 emoji with rotation based on movement
- **Flowers**: 🌸 emoji with vibrant shadows
- **Golden Flowers**: 🌻 emoji with golden glow
- **Purple Flowers**: 💜 emoji with purple shadow
- **Birds**: 🐦 emoji (regular) / 🦅 emoji (giant)
- **Cobwebs**: 🕸️ emoji

## 🔧 Technical Details

### **Game Loop**
- 60 FPS update rate
- Collision detection for all entities
- Dynamic spawning based on probabilities
- Speed effect management for both players

### **Two-Player Features**
- Independent movement controls
- Shared score and game state
- Both players can collect flowers and trigger events
- Both players can be affected by cobwebs and birds
- Individual immunity and speed boost effects

### **Performance**
- Efficient collision detection
- Optimized rendering with shadows and effects
- Smooth animations and transitions 