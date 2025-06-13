import SwiftUI
import UserNotifications

struct ReminderBlockView: View {
    @Binding var selectedTime: Date
    @Binding var isReminderSet: Bool
    var setReminder: () -> Void
    var cancelReminder: () -> Void

    @State private var showTimePicker = false
    @State private var tempSelectedTime = Date()

    var body: some View {
        VStack(spacing: 12) {
            // 🔄 Обновлённое приветствие
            Text("Time to Relax ✨")
                .font(.title2.bold())
                .foregroundColor(.white)

            Text("Turn on reminders to unwind")
                .font(.subheadline)
                .foregroundColor(.white)

            Text("Get daily gentle notifications")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if isReminderSet {
                Text("Reminder set for \(formattedTime(selectedTime))")
                    .font(.subheadline)
                    .foregroundColor(.blue)

                Button(action: {
                    NotificationManager.shared.cancelAllNotifications()
                    cancelReminder()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .font(.subheadline.bold())
                }
                .padding(.top, 4)
            } else {
                Button(action: {
                    tempSelectedTime = selectedTime
                    showTimePicker = true
                }) {
                    Text("Set Reminder")
                        .foregroundColor(.blue)
                        .font(.subheadline.bold())
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(red: 12/255, green: 14/255, blue: 38/255).opacity(0.85))
        .cornerRadius(24)
        .padding(.horizontal, 24)
        .sheet(isPresented: $showTimePicker) {
            VStack(spacing: 24) {
                Text("Select Time")
                    .font(.headline)

                DatePicker("", selection: $tempSelectedTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()

                Button("Confirm") {
                    NotificationManager.shared.requestAuthorizationIfNeeded { granted in
                        if granted {
                            NotificationManager.shared.scheduleNotification(
                                at: tempSelectedTime,
                                title: "Take a mindful break",
                                body: "Relax and enjoy your favorite calming sounds"
                            )
                            DispatchQueue.main.async {
                                selectedTime = tempSelectedTime
                                setReminder()
                                showTimePicker = false
                            }
                        } else {
                            print("❌ Permission not granted for notifications")
                        }
                    }
                }
                .foregroundColor(.blue)
                .padding(.bottom)
            }
            .presentationDetents([.fraction(0.3)])
        }
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
