import Foundation

struct Sound: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let fileName: String
    let imageName: String
    var isPlaying: Bool
    var volume: Float
    var isPremium: Bool // ✅ Добавлено

    init(
        id: UUID = UUID(),
        name: String,
        fileName: String,
        imageName: String,
        isPlaying: Bool = false,
        volume: Float = 1.0,
        isPremium: Bool = false // ✅ по умолчанию false
    ) {
        self.id = id
        self.name = name
        self.fileName = fileName
        self.imageName = imageName
        self.isPlaying = isPlaying
        self.volume = volume
        self.isPremium = isPremium
    }
}
