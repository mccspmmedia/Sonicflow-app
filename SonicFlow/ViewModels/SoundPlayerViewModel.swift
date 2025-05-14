import Foundation
import AVFoundation
import AudioToolbox

class SoundPlayerViewModel: ObservableObject {
    @Published var allSounds: [Sound] = []
    @Published var recentlyPlayed: [Sound] = []
    @Published var favoriteSounds: [Sound] = []
    @Published var currentSound: Sound? = nil
    @Published var showTimer: Bool = false

    @Published var isTimerRunning: Bool = false
    @Published var timeRemaining: Int = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?

    enum SoundCardStyle {
        case light, dark
    }

    // MARK: - Sound Categories
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

    func play(_ sound: Sound) {
        if currentSound?.id != sound.id {
            stopAllSounds()
            playSound(sound)
        } else {
            player?.play()
        }
    }

    func pauseCurrentSound() {
        player?.pause()
    }

    func stopAllSounds() {
        player?.stop()
        player = nil
        markAllSoundsAsStopped()
        currentSound = nil
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

    func setVolume(for sound: Sound, to volume: Float) {
        if currentSound?.id == sound.id {
            player?.volume = volume
        }
    }

    func startCountdown(minutes: Int) {
        guard currentSound != nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.startCountdown(minutes: minutes)
            }
            return
        }

        timer?.invalidate()
        timeRemaining = minutes * 60
        isTimerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.timeRemaining > 0 {
                self.timeRemaining -= 1

                if self.timeRemaining <= 10, let sound = self.currentSound {
                    let volumeFactor = Float(self.timeRemaining) / 10.0
                    self.setVolume(for: sound, to: volumeFactor)
                }
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.isTimerRunning = false
                self.timeRemaining = 0
                self.stopAllSounds()
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }

    func cancelCountdown() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        timeRemaining = 0
    }

    func toggleFavorite(_ sound: Sound) {
        if favoriteSounds.contains(sound) {
            favoriteSounds.removeAll { $0.id == sound.id }
        } else {
            favoriteSounds.append(sound)
        }
        saveFavoriteSounds()
    }

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
