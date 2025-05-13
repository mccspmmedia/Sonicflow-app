import SwiftUI
import AVFoundation
import AudioToolbox

struct TimerPopupView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedMinutes: Int = 10
    @State private var timeRemaining: Int = 0
    @State private var timerRunning = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 24) {
            Text("Set Timer")
                .font(.title2.bold())
                .foregroundColor(.white)

            Picker("Minutes", selection: $selectedMinutes) {
                ForEach([5, 10, 15, 30, 45, 60], id: \.self) { minute in
                    Text("\(minute) minutes").tag(minute)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 100)

            Button(action: {
                startTimer()
                dismiss()
            }) {
                Text("Start Timer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.9))
                    .cornerRadius(12)
            }

            Button("Cancel") {
                cancelTimer()
                dismiss()
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color("DarkBlue").opacity(0.95))
        .cornerRadius(24)
        .padding()
        .onDisappear {
            cancelTimer()
        }
    }

    private func startTimer() {
        timeRemaining = selectedMinutes * 60
        timerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1

                if timeRemaining <= 10 {
                    let volumeFactor = Float(timeRemaining) / 10.0
                    if let current = soundVM.currentSound {
                        soundVM.setVolume(for: current, to: volumeFactor)
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

    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        timeRemaining = 0
    }
}
