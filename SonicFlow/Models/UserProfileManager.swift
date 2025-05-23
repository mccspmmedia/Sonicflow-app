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

    // MARK: - Очистка при удалении аккаунта

    func clear() {
        defaults.remove(forKey: "userName")
        defaults.set(false, forKey: "isSignedIn")
    }
}
