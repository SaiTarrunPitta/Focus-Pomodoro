# Focus Pomodoro

A modern, anime-inspired Pomodoro timer for iOS, built in SwiftUI.

---

## ✨ Features

- **Customizable**: Set work and break durations, and total study period.
- **Smart Schedules**: Alternating 45-min focus, 10/25/10-min breaks, perfect for deep study or work sessions.
- **Beautiful UI**: Neon glow, glassy cards, and Solo Leveling-inspired background.
- **Confetti Celebration**: Finishing a Pomodoro rewards you with animated confetti and a “Grandmaster” alert.
- **Persistent Stats**: Tracks your all-time Pomodoros completed.
- **Offline-First**: No login, no cloud—your data stays on your device.

---

## 🚀 Getting Started

### Prerequisites

- Xcode 15+ (Swift 5.9+)
- iOS 16+ device or simulator

### Setup

1. **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/Focus-Pomodoro.git
    cd Focus-Pomodoro
    ```

2. **Open the project in Xcode**
    - Double-click `Focus-Pomodoro.xcodeproj` (or `.xcworkspace`).

3. **Install ConfettiSwiftUI**
    - In Xcode:  
      Go to **File > Add Packages…**  
      Add this URL:  
      ```
      https://github.com/simibac/ConfettiSwiftUI
      ```

4. **Add Assets (Optional)**
    - You can add your own background image (`soloBG`) and app icon in the asset catalog.

5. **Build and Run**
    - Choose your iPhone or a simulator and click **Run**.

---

## 📝 Usage

- Set your session durations and total study time.
- Tap **Build Schedule** to generate your plan.
- Start/pause/reset your Pomodoro session.
- Enjoy confetti and alerts as you progress.
- Stats are automatically saved and shown at the bottom.

---

## ⚙️ Customization

- **Theme**: Edit `Assets.xcassets` for colors (`HeroBlue`, `NightBlack`) and images (`soloBG`).
- **Fonts**: Add your favorite font (like Bebas Neue) and set it in the title.
- **Sounds and Effects**: Easily add or swap in new alerts and animations.

---

## 📦 Folder Structure

Focus-Pomodoro/
├── Assets.xcassets/
├── PomodoroViewModel.swift
├── ContentView.swift
├── Focus_PomodoroApp.swift
└── README.md 

> **Inspired by Solo Leveling. Built for focus.**
