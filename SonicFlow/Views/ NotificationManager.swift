import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private let reminderTimeKey = "reminderTime"
    private let notificationEnabledKey = "notificationEnabled"

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func scheduleNotification(at time: Date, title: String, body: String) {
        cancelAllNotifications()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        dateComponents.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)

        // Save preferences
        UserDefaults.standard.set(true, forKey: notificationEnabledKey)
        UserDefaults.standard.set(time, forKey: reminderTimeKey)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(false, forKey: notificationEnabledKey)
    }

    func isNotificationEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: notificationEnabledKey)
    }

    func getReminderTime() -> Date {
        return UserDefaults.standard.object(forKey: reminderTimeKey) as? Date ?? defaultTime()
    }

    private func defaultTime() -> Date {
        var components = DateComponents()
        components.hour = 20
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}
