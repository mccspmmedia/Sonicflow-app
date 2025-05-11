import SwiftUI

struct ReminderModalView: View {
    @Binding var isPresented: Bool
    @Binding var reminderDate: Date
    @Binding var notificationsEnabled: Bool

    var title: String
    var bodyText: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()

            VStack(spacing: 20) {
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)

                Text(bodyText)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                DatePicker(
                    "Reminder Time",
                    selection: $reminderDate,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .colorScheme(.dark)

                HStack(spacing: 20) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                    }

                    Button(action: {
                        notificationsEnabled = true
                        NotificationManager.shared.scheduleNotification(
                            at: reminderDate,
                            title: title,
                            body: bodyText
                        )
                        isPresented = false
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color("DarkBlue"))
            .cornerRadius(20)
            .padding(40)
        }
    }
}
