//
//  PomodoroViewModel.swift
//  Focus Time - Pomodoro App
//
//  Created by Tarrun on 7/29/25.
//

import SwiftUI
import UserNotifications

struct TimerSession {
    let duration: Int      // seconds
    let isBreak: Bool
}

class PomodoroViewModel: ObservableObject {
    @Published var schedule: [TimerSession] = []
    @Published var currentIndex: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var timerRunning = false
    @Published var completedSessions = 0

    // Customizable durations (default values)
    @Published var workDuration: Int = 45 * 60
    @Published var shortBreakDuration: Int = 10 * 60
    @Published var longBreakDuration: Int = 25 * 60

    @AppStorage("completedPomodoros") var completedPomodoros: Int = 0
    @Published var shouldCelebrate = false

    var timer: Timer?

    // Builds the schedule based on total hours and current duration settings
    func buildSchedule(totalHours: Int) {
        let breaks = [shortBreakDuration, longBreakDuration, shortBreakDuration]
        var sessions: [TimerSession] = []
        var totalSeconds = totalHours * 60 * 60
        var breakIndex = 0

        while totalSeconds >= workDuration {
            sessions.append(TimerSession(duration: workDuration, isBreak: false))
            totalSeconds -= workDuration
            if totalSeconds >= 60 {
                let breakDuration = breaks[breakIndex % 3]
                sessions.append(TimerSession(duration: breakDuration, isBreak: true))
                totalSeconds -= breakDuration
                breakIndex += 1
            }
        }
        self.schedule = sessions
        self.currentIndex = 0
        self.timeRemaining = sessions.first?.duration ?? 0
        self.completedSessions = 0
    }

    func startTimer() {
        if timerRunning { return }
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.sendNotification()
                self.moveToNextSession()
            }
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }

    func resetTimer() {
        pauseTimer()
        currentIndex = 0
        timeRemaining = schedule.first?.duration ?? 0
        completedSessions = 0
    }

    func moveToNextSession() {
        pauseTimer()
        if currentIndex < schedule.count - 1 {
            currentIndex += 1
            timeRemaining = schedule[currentIndex].duration
            if !schedule[currentIndex].isBreak {
                completedSessions += 1
                completedPomodoros += 1
                shouldCelebrate = true
            }
            startTimer()
        } else {
            // All done!
            currentIndex = 0
            timeRemaining = 0
        }
    }

    func sendNotification() {
        let isBreak = schedule[safe: currentIndex]?.isBreak ?? false
        let content = UNMutableNotificationContent()
        if !isBreak {
            content.title = "Work Session Complete!"
            content.body = "Well done! You are a Grandmaster! 🎉"
        } else {
            content.title = "Break Over!"
            content.body = "Time to get back to work!"
        }
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

// Helper for safe array access to avoid crash
extension Array {
    subscript(safe index: Int) -> Element? {
        (indices.contains(index)) ? self[index] : nil
    }
}
