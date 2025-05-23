import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard

    // MARK: - Базовые типы

    func set(_ value: Any?, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func getString(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }

    func getBool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }

    func getInt(forKey key: String) -> Int {
        defaults.integer(forKey: key)
    }

    func remove(forKey key: String) {
        defaults.removeObject(forKey: key)
    }

    // MARK: - Codable поддержка

    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            defaults.set(data, forKey: key)
        } catch {
            print("❌ Ошибка сохранения Codable объекта: \(error.localizedDescription)")
        }
    }

    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
