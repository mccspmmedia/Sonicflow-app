import Foundation

struct SoundStorageManager {
    static let recentKey = "recentlyPlayed"
    static let favoriteKey = "favoriteSounds"

    // MARK: - Save

    static func saveRecent(_ sounds: [Sound]) {
        if let data = try? JSONEncoder().encode(sounds) {
            UserDefaults.standard.set(data, forKey: recentKey)
        }
    }

    static func saveFavorites(_ sounds: [Sound]) {
        if let data = try? JSONEncoder().encode(sounds) {
            UserDefaults.standard.set(data, forKey: favoriteKey)
        }
    }

    // MARK: - Load

    static func loadRecent() -> [Sound] {
        guard let data = UserDefaults.standard.data(forKey: recentKey),
              let sounds = try? JSONDecoder().decode([Sound].self, from: data) else {
            return []
        }
        return sounds
    }

    static func loadFavorites() -> [Sound] {
        guard let data = UserDefaults.standard.data(forKey: favoriteKey),
              let sounds = try? JSONDecoder().decode([Sound].self, from: data) else {
            return []
        }
        return sounds
    }

    // MARK: - Delete All

    static func deleteAll() {
        UserDefaults.standard.removeObject(forKey: recentKey)
        UserDefaults.standard.removeObject(forKey: favoriteKey)
    }
}
