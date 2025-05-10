import SwiftUI

struct TimerPopupView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedMinutes: Int = 10
    @State private var isTimerSet: Bool = false

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
                soundVM.setTimer(minutes: selectedMinutes)
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
                dismiss()
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color("DarkBlue").opacity(0.95))
        .cornerRadius(24)
        .padding()
    }
}
