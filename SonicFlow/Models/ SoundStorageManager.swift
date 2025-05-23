import Foundation

struct SoundStorageManager {
    static let recentKey = "recentlyPlayed"
    static let favoriteKey = "favoriteSounds"

    private static let defaults = UserDefaultsManager.shared

    // MARK: - Save

    @discardableResult
    static func saveRecent(_ sounds: [Sound]) -> Bool {
        save(sounds, forKey: recentKey)
    }

    @discardableResult
    static func saveFavorites(_ sounds: [Sound]) -> Bool {
        save(sounds, forKey: favoriteKey)
    }

    private static func save(_ sounds: [Sound], forKey key: String) -> Bool {
        defaults.save(sounds, forKey: key)
        return true
    }

    // MARK: - Load

    static func loadRecent() -> [Sound] {
        load(forKey: recentKey)
    }

    static func loadFavorites() -> [Sound] {
        load(forKey: favoriteKey)
    }

    private static func load(forKey key: String) -> [Sound] {
        return defaults.load(forKey: key, as: [Sound].self) ?? []
    }

    // MARK: - Delete

    static func deleteAll() {
        clear(forKey: recentKey)
        clear(forKey: favoriteKey)
    }

    static func clear(forKey key: String) {
        defaults.remove(forKey: key)
    }
}
