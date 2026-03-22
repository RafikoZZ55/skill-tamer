# Skill Tamer

Skill Tamer is a session tracking application built with Flutter that uses gamification elements to help manage skill development. It allows users to track practice sessions, manage skill attributes, and complete missions with probabilities tied to their progress.

## Features

- **Session Tracking**: Focused timers for skill practice with historical logging.
- **Skill Attributes**: Develop skills across Cognitive, Creative, and Social attributes.
- **Mission System**: Probability-based missions that scale with your current skill levels.
- **Rewards**: Collect and use items like session boosts, attribute resets, and temporary buffs.
- **Analytics**: Visualization of session history and progress.
- **Theme**: High-contrast dark theme with cyan and magenta accents.

## Technical Stack

- **Framework**: Flutter (Material 3)
- **State Management**: Riverpod
- **Storage**: Hive (Local Database)
- **Audio**: just_audio
- **Charts**: Syncfusion Flutter Charts

## Getting Started

### Prerequisites

- Flutter SDK (>=2.17.0)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/RafikoZZ55/skill-tamer.git
   cd skill-tamer
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Hive adapters:
   ```bash
   flutter pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/data`: Models, Hive states, and Riverpod controllers.
- `lib/pages`: Main application pages.
- `lib/views`: Feature-specific views (Backpack, Missions, History).
- `lib/components`: Shared UI components.
- `lib/constant`: Application constants and durations.

## License

This project is licensed under the MIT License.
