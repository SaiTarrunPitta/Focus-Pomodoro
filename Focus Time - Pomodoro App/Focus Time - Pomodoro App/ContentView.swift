import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @StateObject var vm = PomodoroViewModel()
    @State private var selectedHours = 3
    @State private var showAlert = false
    @State private var confettiCounter = 0

    var body: some View {
        ZStack {
            // Background gradient and blue glow
            LinearGradient(
                gradient: Gradient(colors: [Color("HeroBlue"), Color("NightBlack")]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(Color.cyan.opacity(0.18))
                .blur(radius: 90)
                .frame(width: 420, height: 320)
                .offset(x: -130, y: -300)
            
            // Confetti using latest API!
//            ConfettiCannon(
//                trigger: $confettiCounter,
//                repetitions: 1,
//                repetitionInterval: 0.0,
//                colors: [Color.cyan, Color.blue, Color.purple]
//            )
            ConfettiCannon(
                trigger: $confettiCounter,
                colors: [Color.cyan, Color.blue, Color.purple],
                repetitions: 1,
                repetitionInterval: 0.0
            )

            .allowsHitTesting(false)

            VStack(spacing: 28) {
                // App Title
                Text("Focus Pomodoro")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: Color.cyan.opacity(0.24), radius: 10, y: 4)
                    .padding(.top, 16)

                // Glassy card for settings
                VStack(spacing: 18) {
                    HStack(spacing: 18) {
                        TimerPicker(title: "Work", selection: $vm.workDuration, options: [25, 30, 45, 60], color: .cyan)
                        TimerPicker(title: "Short Break", selection: $vm.shortBreakDuration, options: [5, 10, 15], color: .blue)
                        TimerPicker(title: "Long Break", selection: $vm.longBreakDuration, options: [15, 25, 30], color: .purple)
                    }
                    VStack(spacing: 8) {
                        Text("Total Study Time")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.55))
                        HStack(spacing: 6) {
                            ForEach(1..<7) { hour in
                                Button(action: { selectedHours = hour }) {
                                    Text("\(hour) hr")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(selectedHours == hour ? Color.cyan.opacity(0.14) : Color.clear)
                                        .foregroundColor(selectedHours == hour ? .cyan : .white.opacity(0.55))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    Button(action: { vm.buildSchedule(totalHours: selectedHours) }) {
                        Text("Build Schedule")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.cyan)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                            .shadow(color: Color.cyan.opacity(0.18), radius: 8, y: 4)
                    }
                    .padding(.top, 2)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(22)
                .shadow(color: Color.cyan.opacity(0.14), radius: 18, y: 10)
                .padding(.horizontal)

                Spacer()
                VStack(spacing: 10) {
                    if !vm.schedule.isEmpty {
                        // Focus/Break Label with neon shadow
                        Text(vm.schedule[vm.currentIndex].isBreak ? "Break" : "Focus")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(vm.schedule[vm.currentIndex].isBreak ? Color.cyan : Color.blue)
                            .shadow(color: Color.cyan.opacity(0.8), radius: 16, x: 0, y: 0)
                            .padding(.bottom, 6)
                        // Timer with neon shadow
                        Text(timeString(vm.timeRemaining))
                            .font(.system(size: 84, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                            .shadow(color: Color.cyan.opacity(0.55), radius: 28, x: 0, y: 0)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 12)
                        HStack(spacing: 28) {
                            CircleButton(
                                title: vm.timerRunning ? "Pause" : "Start",
                                color: vm.timerRunning ? .purple : .cyan,
                                action: {
                                    if vm.timerRunning { vm.pauseTimer() } else { vm.startTimer() }
                                }
                            )
                            CircleButton(
                                title: "Reset",
                                color: .gray,
                                action: { vm.resetTimer() }
                            )
                        }
                        .padding(.vertical, 12)
                        VStack(spacing: 2) {
                            Text("Session \(min(vm.currentIndex / 2 + 1, vm.schedule.filter{!$0.isBreak}.count)) of \(vm.schedule.filter{!$0.isBreak}.count)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.55))
                            Text("Completed: \(vm.completedSessions)")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.45))
                        }
                        .padding(.top, 4)
                    } else {
                        Text("Tap 'Build Schedule' to begin")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.55))
                            .padding(.top, 16)
                    }
                }
                .frame(maxWidth: .infinity)
                Spacer()
                // All-time stats
                Text("All-Time Pomodoros: \(vm.completedPomodoros)")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 8)
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
        .onReceive(vm.$shouldCelebrate) { shouldCelebrate in
            if shouldCelebrate {
                showAlert = true
                confettiCounter += 1 // Launch confetti!
                vm.shouldCelebrate = false
            }
        }
        .alert("Well done! You are a Grandmaster! 🎉", isPresented: $showAlert) {
            Button("Thanks!", role: .cancel) {}
        }
    }

    func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

// MARK: - Timer Picker Helper
struct TimerPicker: View {
    let title: String
    @Binding var selection: Int
    let options: [Int]
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.75))
            HStack(spacing: 0) {
                ForEach(options, id: \.self) { min in
                    Button(action: { selection = min * 60 }) {
                        Text("\(min)")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .frame(width: 34, height: 32)
                            .background(selection == min * 60 ? color.opacity(0.18) : Color.clear)
                            .foregroundColor(selection == min * 60 ? color : .white.opacity(0.55))
                            .cornerRadius(7)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.04))
            )
        }
        .padding(6)
    }
}

// MARK: - Circle Button Helper
struct CircleButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .frame(width: 92, height: 48)
                .background(color.opacity(0.87))
                .foregroundColor(.white)
                .cornerRadius(16)
                .shadow(color: color.opacity(0.16), radius: 6, y: 2)
        }
    }
}
