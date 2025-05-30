import Foundation

class UserProfileManager {
    static let shared = UserProfileManager()
    private init() {}

    private let defaults = UserDefaultsManager.shared

    // MARK: - Хранимые значения

    var userName: String? {
        get { defaults.getString(forKey: "userName") }
        set { defaults.set(newValue, forKey: "userName") }
    }

    var isSignedIn: Bool {
        get { defaults.getBool(forKey: "isSignedIn") }
        set { defaults.set(newValue, forKey: "isSignedIn") }
    }

    // MARK: - Полная очистка при удалении аккаунта

    func clear() {
        // Удаление всех пользовательских ключей, относящихся к профилю
        defaults.remove(forKey: "userName")
        defaults.remove(forKey: "userEmail") // если есть
        defaults.remove(forKey: "profileImageURL") // если есть
        defaults.remove(forKey: "signInMethod") // Google / Apple и т.п.
        
        // Явно сбросить флаг входа
        defaults.set(false, forKey: "isSignedIn")

        print("✅ UserProfileManager: профиль очищен")
    }
}
