import SwiftUI
import AVFoundation
import AudioToolbox

struct TimerView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var selectedMinutes: Int = 5
    @State private var timeRemaining: Int = 0
    @State private var timerRunning = false
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            Text("Set a Timer")
                .font(.title2)
                .foregroundColor(.white)

            Picker("Minutes", selection: $selectedMinutes) {
                ForEach(1..<61) { minute in
                    Text("\(minute) min").tag(minute)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 120)
            .clipped()
            .colorScheme(.dark)

            Button(action: {
                startTimer()
            }) {
                Text(timerRunning ? "Timer Running..." : "Start Timer")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(timerRunning ? Color.gray : Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(timerRunning)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .padding()
        .onDisappear {
            cancelTimer()
        }
    }

    func startTimer() {
        timeRemaining = selectedMinutes * 60
        timerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1

                // Gradual fade out in last 10 seconds
                if timeRemaining <= 10 {
                    let volumeFactor = Float(timeRemaining) / 10.0
                    if let currentSound = soundVM.currentSound {
                        soundVM.setVolume(for: currentSound, to: volumeFactor)
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
