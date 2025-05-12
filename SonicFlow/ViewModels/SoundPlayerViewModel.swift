import Foundation
import AVFoundation

class SoundPlayerViewModel: ObservableObject {
    @Published var allSounds: [Sound] = []
    @Published var recentlyPlayed: [Sound] = []
    @Published var favoriteSounds: [Sound] = []
    @Published var currentSound: Sound? = nil
    @Published var showTimer: Bool = false

    private var player: AVAudioPlayer?
    private var timer: Timer?

    // MARK: - Nature Sounds
    let natureSoundList: [Sound] = [
        Sound(name: "Ocean", fileName: "sea", imageName: "sea"),
        Sound(name: "Forest", fileName: "forest", imageName: "forest"),
        Sound(name: "Campfire", fileName: "fire", imageName: "fire"),
        Sound(name: "Rain", fileName: "rain", imageName: "rain"),
        Sound(name: "Rain with Thunder", fileName: "rain_thunder", imageName: "rain_thunder"),
        Sound(name: "Rain in Forest", fileName: "rain_forest", imageName: "rain_forest"),
        Sound(name: "Rain in Tent", fileName: "rain_tent", imageName: "rain_tent"),
        Sound(name: "Storm", fileName: "storm", imageName: "storm"),
        Sound(name: "Waterfall", fileName: "waterfall", imageName: "waterfall"),
        Sound(name: "Wind", fileName: "wind", imageName: "wind"),
        Sound(name: "Snow Footsteps", fileName: "snow_steps", imageName: "snow_steps"),
        Sound(name: "Stream", fileName: "stream", imageName: "stream"),
        Sound(name: "Jungle", fileName: "jungle", imageName: "jungle")
    ]

    // MARK: - Sleep Sounds
    let sleepSoundList: [Sound] = [
        Sound(name: "White Noise", fileName: "white_noise", imageName: "white_noise"),
        Sound(name: "Crickets at Night", fileName: "crickets", imageName: "crickets"),
        Sound(name: "Rain on Window", fileName: "rain_window", imageName: "rain_window"),
        Sound(name: "Breathing Sound", fileName: "breathing", imageName: "breathing")
    ]

    // MARK: - Ambience Sounds
    let ambienceSoundList: [Sound] = [
        Sound(name: "Cafe", fileName: "cafe", imageName: "cafe"),
        Sound(name: "Library", fileName: "library", imageName: "library"),
        Sound(name: "City Night", fileName: "city", imageName: "city"),
        Sound(name: "Train", fileName: "train", imageName: "train")
    ]

    // MARK: - Meditation Sounds
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
        allSounds = allAvailableSounds
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

    func toggleSound(_ sound: Sound) {
        if currentSound?.id == sound.id {
            stopAllSounds()
        } else {
            playExclusive(sound)
        }
    }

    func playExclusive(_ sound: Sound) {
        stopAllSounds()
        playSound(sound)
    }

    private func playSound(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") else {
            print("❌ File not found: \(sound.fileName).mp3")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = sound.volume
            player?.prepareToPlay()
            player?.play()

            currentSound = sound
            markSoundAsPlaying(sound)
            addToRecentlyPlayed(sound: sound)
        } catch {
            print("❌ Playback error: \(error.localizedDescription)")
        }
    }

    func stopAllSounds() {
        player?.stop()
        player = nil
        markAllSoundsAsStopped()
        currentSound = nil
    }

    func setVolume(for sound: Sound, to volume: Float) {
        if currentSound?.id == sound.id {
            player?.volume = volume
        }
        allSounds.indices.forEach { index in
            if allSounds[index].id == sound.id {
                allSounds[index].volume = volume
            }
        }
    }

    func toggleFavorite(_ sound: Sound) {
        if favoriteSounds.contains(sound) {
            favoriteSounds.removeAll { $0.id == sound.id }
        } else {
            favoriteSounds.append(sound)
        }
        saveFavoriteSounds()
    }

    var currentlyPlaying: Sound? {
        return currentSound
    }

    // MARK: - Recently Played

    func addToRecentlyPlayed(sound: Sound) {
        if let index = recentlyPlayed.firstIndex(of: sound) {
            recentlyPlayed.remove(at: index)
        }
        recentlyPlayed.insert(sound, at: 0)
        if recentlyPlayed.count > 5 {
            recentlyPlayed = Array(recentlyPlayed.prefix(5))
        }
        saveRecentlyPlayed()
    }

    // MARK: - Persistence

    private func saveRecentlyPlayed() {
        if let data = try? JSONEncoder().encode(recentlyPlayed) {
            UserDefaults.standard.set(data, forKey: "recentlyPlayed")
        }
    }

    private func loadRecentlyPlayed() {
        if let data = UserDefaults.standard.data(forKey: "recentlyPlayed"),
           let saved = try? JSONDecoder().decode([Sound].self, from: data) {
            recentlyPlayed = saved
        }
    }

    private func saveFavoriteSounds() {
        if let data = try? JSONEncoder().encode(favoriteSounds) {
            UserDefaults.standard.set(data, forKey: "favoriteSounds")
        }
    }

    private func loadFavoriteSounds() {
        if let data = UserDefaults.standard.data(forKey: "favoriteSounds"),
           let saved = try? JSONDecoder().decode([Sound].self, from: data) {
            favoriteSounds = saved
        }
    }

    // MARK: - Timer

    func setTimer(minutes: Int) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(minutes * 60), repeats: false) { _ in
            self.stopAllSounds()
        }
    }

    // MARK: - Helper

    private func markSoundAsPlaying(_ sound: Sound) {
        allSounds.indices.forEach { index in
            allSounds[index].isPlaying = allSounds[index].id == sound.id
        }
    }

    private func markAllSoundsAsStopped() {
        allSounds.indices.forEach { index in
            allSounds[index].isPlaying = false
        }
    }
}
