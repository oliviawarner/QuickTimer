import SwiftUI
import WatchKit
import UserNotifications

struct TimerView: View {
    @State var timeRemaining: Int = 60 // Default timer duration
    @State var timerActive = false
    @State var timer: Timer? = nil
    @State var selectedTime: Int = 60 // Selected time from Picker
    @State var showPicker = true // Controls visibility of Picker
    @State var timerFinished = false // Indicates if the timer has completed

    var body: some View {
        ZStack {
            VStack(spacing: 8) { // Compact spacing
                // Progress Ring and Timer Display
                ZStack {
                    ProgressRing(progress: showPicker ? 1.0 : CGFloat(timeRemaining) / CGFloat(selectedTime))
                        .frame(width: 80, height: 80) // Compact size
                    Text(formatTime())
                        .font(.caption) // Timer countdown text
                        .bold()
                }

                // Timer Picker (visible only if not running)
                if showPicker {
                    Picker("Set Timer", selection: $selectedTime) {
                        ForEach(1...600, id: \.self) { time in
                            Text("\(time)").tag(time)
                        }
                    }
                    .labelsHidden()
                    .frame(height: 50) // Compact height for Picker

                    Button("Set Timer") {
                        setCustomTimer()
                    }
                    .buttonStyle(CompactButtonStyle(color: .blue))
                }

                // Timer Controls (Start/Pause and Reset buttons)
                if !showPicker {
                    Button(action: toggleTimer) {
                        Text(timerActive ? "Pause" : "Start")
                    }
                    .buttonStyle(CompactButtonStyle(color: timerActive ? .yellow : .green))

                    Button(action: resetTimer) {
                        Text("Reset")
                    }
                    .buttonStyle(CompactButtonStyle(color: .red))
                }
            }

            // Full-Screen Overlay with Confetti
            if timerFinished {
                ZStack {
                    // Background Layer
                    Color.black.opacity(0.8) // Dimmed background
                        .ignoresSafeArea()

                    // Confetti Layer
                    ConfettiView()
                        .ignoresSafeArea() // Ensure it fills the screen
                        .zIndex(0) // Send to the back

                    // Foreground Layer for Text
                    VStack {
                        Spacer() // Push content dynamically downward

                        Text("Time's Up!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .padding(.bottom, 100) // Adjust as needed to move the text upward

                        Spacer() // Add flexibility below
                    }
                    .zIndex(1) // Ensure text is always above confetti
                }
                .onTapGesture {
                    resetTimer() // Dismiss overlay on tap
                }
            }
        }
        .padding(5) // Compact padding
        .animation(.easeInOut, value: timerFinished) // Smooth animations
        .onAppear {
            requestNotificationPermission()
        }
        .onDisappear {
            timer?.invalidate() // Stop the timer when the view disappears
        }
    }

    // Toggle Timer Start/Pause
    internal func toggleTimer() {
        if timerActive {
            timer?.invalidate()
            timerActive = false
        } else {
            timerActive = true
            startTimer()
        }
    }

    // Start Timer
    internal func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                timerActive = false
                timerFinished = true // Trigger overlay
                triggerHapticFeedback() // Play haptic feedback
            }
        }
    }

    // Reset Timer
    internal func resetTimer() {
        timer?.invalidate()
        timeRemaining = selectedTime
        timerActive = false
        timerFinished = false // Hide overlay
        showPicker = true // Show the picker again
    }

    // Set Custom Timer
    private func setCustomTimer() {
        timeRemaining = selectedTime
        timer?.invalidate()
        timerActive = false
        timerFinished = false // Hide overlay
        showPicker = false // Hide the picker after setting the timer
    }

    // Haptic Feedback
    private func triggerHapticFeedback() {
        WKInterfaceDevice.current().play(.success) // Play success haptic pattern
    }

    // Request Notification Permission
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }

    // Format Time for Display
    private func formatTime() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
