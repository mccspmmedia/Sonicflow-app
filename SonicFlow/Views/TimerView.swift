import SwiftUI
import AVFoundation

struct TimerView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var selectedMinutes: Int = 10
    @State private var timerRunning = false
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer? = nil

    let minuteOptions = Array(stride(from: 5, through: 120, by: 5))

    var body: some View {
        VStack(spacing: 32) {
            Text("Auto-Stop Timer")
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            Picker("Minutes", selection: $selectedMinutes) {
                ForEach(minuteOptions, id: \.self) { min in
                    Text("\(min) min").tag(min)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)
            .clipped()

            if timerRunning {
                CircularTimerView(timeRemaining: timeRemaining, totalTime: selectedMinutes * 60)
                    .frame(width: 150, height: 150)

                Button("Cancel Timer") {
                    cancelTimer()
                }
                .foregroundColor(.red)
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)

            } else {
                Button("Start Timer") {
                    startTimer()
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .onDisappear {
            cancelTimer()
        }
    }

    func startTimer() {
        timeRemaining = selectedMinutes * 60
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if timeRemaining > 0 {
                timeRemaining -= 1

                // Gradual volume fade in last 10 seconds
                if timeRemaining <= 10 {
                    let volumeFactor = Float(timeRemaining) / 10.0
                    for i in soundVM.allSounds.indices {
                        soundVM.setVolume(for: soundVM.allSounds[i], to: volumeFactor)
                    }
                }

            } else {
                timer?.invalidate()
                timer = nil
                timerRunning = false
                soundVM.stopAllSounds()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        timeRemaining = 0
    }
}

struct CircularTimerView: View {
    let timeRemaining: Int
    let totalTime: Int

    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return Double(totalTime - timeRemaining) / Double(totalTime)
    }

    var timeText: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.2), value: progress)

            Text(timeText)
                .font(.title2.bold())
                .foregroundColor(.white)
        }
    }
}
