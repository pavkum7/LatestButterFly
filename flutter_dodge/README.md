# Flutter Dodge

A beautiful arcade-style endless runner game built with Flutter where you control a butterfly collecting flowers while dodging butterfly nets.

## 🎮 Game Features

- **Beautiful Graphics**: Hand-drawn butterfly, flowers, and nets with smooth animations
- **Intuitive Controls**: Tap or drag to move the butterfly up and down
- **Progressive Difficulty**: Game speed increases as you collect more flowers
- **Score System**: Track your current score and high score
- **Responsive Design**: Works on various screen sizes
- **Smooth Gameplay**: 60 FPS game loop for fluid animations

## 🎯 How to Play

1. **Objective**: Control a butterfly and collect as many flowers as possible while avoiding butterfly nets
2. **Controls**: 
   - Tap the top half of the screen to move up
   - Tap the bottom half of the screen to move down
   - Or drag your finger up/down to control movement
3. **Scoring**: Each flower collected gives you 10 points
4. **Game Over**: The game ends when your butterfly hits a net

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone or download this project
2. Navigate to the project directory:
   ```bash
   cd flutter_dodge
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the game:
   ```bash
   flutter run
   ```

### Running on Different Platforms

- **Android**: `flutter run -d android`
- **iOS**: `flutter run -d ios`
- **Web**: `flutter run -d chrome`
- **Desktop**: `flutter run -d macos` (or windows/linux)

## 🏗️ Project Structure

```
flutter_dodge/
├── lib/
│   ├── models/
│   │   ├── game_entities.dart    # Game objects (Butterfly, Flower, Net)
│   │   └── game_state.dart       # Game logic and state management
│   ├── widgets/
│   │   ├── butterfly_widget.dart # Butterfly rendering
│   │   ├── flower_widget.dart    # Flower rendering
│   │   ├── net_widget.dart       # Net rendering
│   │   └── game_screen.dart      # Main game screen
│   └── main.dart                 # App entry point
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

## 🎨 Game Mechanics

### Core Components

- **Butterfly**: The player character that can move up and down
- **Flowers**: Collectible items that increase your score
- **Nets**: Obstacles that end the game when hit
- **Background**: Scrolling sky with cloud decorations

### Game Loop

1. **Input Handling**: Player controls butterfly movement
2. **Object Updates**: Flowers and nets move from right to left
3. **Collision Detection**: Check for flower collection and net collisions
4. **Object Spawning**: Randomly spawn new flowers and nets
5. **Score Tracking**: Update score and high score
6. **Rendering**: Draw all game objects with smooth animations

## 🎯 Future Enhancements

- [ ] Sound effects and background music
- [ ] Power-ups and special abilities
- [ ] Different butterfly types
- [ ] Multiple difficulty levels
- [ ] Leaderboard system
- [ ] Particle effects for collisions
- [ ] More visual effects and animations

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🎮 Enjoy Playing!

Have fun playing Flutter Dodge! Try to beat your high score and challenge your friends to do better. The game is designed to be simple yet addictive, perfect for quick gaming sessions. 