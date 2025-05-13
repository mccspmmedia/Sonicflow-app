import SwiftUI
import UserNotifications

struct ReminderBlockView: View {
    @Binding var selectedTime: Date
    @Binding var isReminderSet: Bool
    var setReminder: () -> Void
    var cancelReminder: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("Hello, Dmytro ✨")
                .font(.title2.bold())
                .foregroundColor(.white)

            Text("Enable reminders to relax")
                .font(.subheadline)
                .foregroundColor(.white)

            Text("Get notified daily to unwind and enjoy calming sounds")
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
                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .frame(maxWidth: .infinity)

                Button(action: {
                    NotificationManager.shared.requestAuthorizationIfNeeded { granted in
                        if granted {
                            NotificationManager.shared.scheduleNotification(
                                at: selectedTime,
                                title: "Take a mindful break",
                                body: "Relax and enjoy your favorite calming sounds"
                            )
                            DispatchQueue.main.async {
                                setReminder()
                            }
                        } else {
                            print("❌ Permission not granted for notifications")
                        }
                    }
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
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
