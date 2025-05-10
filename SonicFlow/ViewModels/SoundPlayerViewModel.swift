import Foundation
import AVFoundation

class SoundPlayerViewModel: ObservableObject {
    @Published var allSounds: [Sound] = []
    @Published var recentlyPlayed: [Sound] = []
    @Published var favoriteSounds: [Sound] = []
    @Published var currentSound: Sound? = nil
    @Published var showTimer: Bool = false

    private var players: [AVAudioPlayer?] = []
    private var timer: Timer?

    let natureSoundList: [Sound] = [
        Sound(name: "Ocean", fileName: "sea", imageName: "sea"),
        Sound(name: "Forest", fileName: "forest", imageName: "forest"),
        Sound(name: "Campfire", fileName: "fire", imageName: "fire"),
        Sound(name: "Rain", fileName: "rain", imageName: "rain")
    ]

    let sleepSoundList: [Sound] = [
        Sound(name: "White Noise", fileName: "white_noise", imageName: "white_noise"),
        Sound(name: "Crickets at Night", fileName: "crickets", imageName: "crickets"),
        Sound(name: "Rain on Window", fileName: "rain_window", imageName: "rain_window"),
        Sound(name: "Breathing Sound", fileName: "breathing", imageName: "breathing")
    ]

    let ambienceSoundList: [Sound] = [
        Sound(name: "Cafe", fileName: "cafe", imageName: "cafe"),
        Sound(name: "Library", fileName: "library", imageName: "library"),
        Sound(name: "City Night", fileName: "city", imageName: "city"),
        Sound(name: "Train", fileName: "train", imageName: "train")
    ]

    let meditationSoundList: [Sound] = [
        Sound(name: "Deep Focus", fileName: "deep_focus", imageName: "deep_focus"),
        Sound(name: "Calm Mind", fileName: "calm_mind", imageName: "calm_mind"),
        Sound(name: "Inner Place", fileName: "inner_place", imageName: "inner_place"),
        Sound(name: "Healing Waves", fileName: "healing_waves", imageName: "healing_waves")
    ]

    private var allAvailableSounds: [Sound] {
        natureSoundList + sleepSoundList + ambienceSoundList + meditationSoundList
    }

    init() {
        setupAudioSession()
        loadRecentlyPlayed()
        loadFavoriteSounds()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup error: \(error.localizedDescription)")
        }
    }

    func appendSoundsIfNeeded(_ sounds: [Sound]) {
        for sound in sounds {
            if !allSounds.contains(where: { $0.id == sound.id }) {
                allSounds.append(sound)
                players.append(nil)
            }
        }
        objectWillChange.send()
    }

    func playExclusive(_ sound: Sound) {
        stopAllSounds()
        toggleSound(sound)
    }

    func toggleSound(_ sound: Sound) {
        guard let index = allSounds.firstIndex(where: { $0.id == sound.id }) else { return }
        if allSounds[index].isPlaying {
            stopSound(at: index)
        } else {
            playSound(at: index)
            currentSound = allSounds[index]
        }
    }

    func setVolume(for sound: Sound, to volume: Float) {
        guard let index = allSounds.firstIndex(where: { $0.id == sound.id }) else { return }
        allSounds[index].volume = volume
        players[safe: index]??.volume = volume
        objectWillChange.send()
    }

    private func playSound(at index: Int) {
        guard index < allSounds.count else { return }
        guard let url = Bundle.main.url(forResource: allSounds[index].fileName, withExtension: "mp3") else {
            print("File not found: \(allSounds[index].fileName).mp3")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = allSounds[index].volume
            player.prepareToPlay()
            player.play()

            if index >= players.count {
                players.append(contentsOf: Array(repeating: nil, count: index - players.count + 1))
            }

            players[index] = player
            allSounds[index].isPlaying = true
            currentSound = allSounds[index]
            addToRecentlyPlayed(sound: allSounds[index])
            objectWillChange.send()
        } catch {
            print("Playback error: \(error.localizedDescription)")
        }
    }

    private func stopSound(at index: Int) {
        guard index < players.count else { return }
        players[index]?.stop()
        allSounds[index].isPlaying = false
        currentSound = nil
        objectWillChange.send()
    }

    func stopAllSounds() {
        for i in players.indices {
            players[i]?.stop()
            if i < allSounds.count {
                allSounds[i].isPlaying = false
            }
        }
        currentSound = nil
        objectWillChange.send()
    }

    func pauseAllSounds() {
        for i in players.indices {
            players[i]?.pause()
        }
        for i in allSounds.indices {
            allSounds[i].isPlaying = false
        }
        objectWillChange.send()
    }

    func resumeAllSounds() {
        for i in players.indices {
            players[i]?.play()
        }
        for i in allSounds.indices {
            allSounds[i].isPlaying = true
        }
        objectWillChange.send()
    }

    func removeSound(_ sound: Sound) {
        if let index = allSounds.firstIndex(where: { $0.id == sound.id }) {
            stopSound(at: index)
            allSounds.remove(at: index)
            if index < players.count {
                players.remove(at: index)
            }
            objectWillChange.send()
        }
    }

    func addToRecentlyPlayed(sound: Sound) {
        if let existing = recentlyPlayed.firstIndex(of: sound) {
            recentlyPlayed.remove(at: existing)
        }
        recentlyPlayed.insert(sound, at: 0)
        if recentlyPlayed.count > 5 {
            recentlyPlayed = Array(recentlyPlayed.prefix(5))
        }
        saveRecentlyPlayed()
    }

    func toggleFavorite(_ sound: Sound) {
        if favoriteSounds.contains(sound) {
            favoriteSounds.removeAll { $0 == sound }
        } else {
            favoriteSounds.append(sound)
        }
        saveFavoriteSounds()
    }

    func setTimer(minutes: Int) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(minutes * 60), repeats: false) { _ in
            self.stopAllSounds()
        }
    }

    private func saveRecentlyPlayed() {
        if let data = try? JSONEncoder().encode(recentlyPlayed) {
            UserDefaults.standard.set(data, forKey: "recentlyPlayed")
        }
    }

    private func saveFavoriteSounds() {
        if let data = try? JSONEncoder().encode(favoriteSounds) {
            UserDefaults.standard.set(data, forKey: "favoriteSounds")
        }
    }

    private func loadRecentlyPlayed() {
        if let data = UserDefaults.standard.data(forKey: "recentlyPlayed"),
           let saved = try? JSONDecoder().decode([Sound].self, from: data) {
            recentlyPlayed = saved
        }
    }

    private func loadFavoriteSounds() {
        if let data = UserDefaults.standard.data(forKey: "favoriteSounds"),
           let saved = try? JSONDecoder().decode([Sound].self, from: data) {
            favoriteSounds = saved
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
