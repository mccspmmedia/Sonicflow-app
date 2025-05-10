import Foundation

struct SoundMix: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var soundIDs: [UUID]

    init(id: UUID = UUID(), name: String, soundIDs: [UUID]) {
        self.id = id
        self.name = name
        self.soundIDs = soundIDs
    }
}
