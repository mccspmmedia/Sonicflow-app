import SwiftUI

struct TimerPopupView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedMinutes: Int = 10

    var body: some View {
        VStack(spacing: 24) {
            Text("Set Timer")
                .font(.title2.bold())
                .foregroundColor(.white)

            if soundVM.isTimerRunning {
                VStack(spacing: 8) {
                    Text("Time Remaining")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)

                    Text(formattedTime(soundVM.timeRemaining))
                        .font(.largeTitle.monospacedDigit())
                        .foregroundColor(.green)
                }

                Button("Stop Timer") {
                    soundVM.cancelCountdown()
                    dismiss()
                }
                .foregroundColor(.red)
                .padding(.top)
            } else {
                Picker("Minutes", selection: $selectedMinutes) {
                    ForEach([5, 10, 15, 30, 45, 60], id: \.self) { minute in
                        Text("\(minute) minutes").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 100)

                Button(action: {
                    soundVM.startCountdown(minutes: selectedMinutes)
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
            }

            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color("DarkBlue").opacity(0.95))
        .cornerRadius(24)
        .padding()
    }

    private func formattedTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
