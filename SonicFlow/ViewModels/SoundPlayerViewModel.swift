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

    @Published var isPremiumUnlocked: Bool {
        didSet {
            UserDefaultsManager.shared.set(isPremiumUnlocked, forKey: "isPremiumUnlocked")
        }
    }

    private var player: AVAudioPlayer?
    private var timer: Timer?

    enum SoundCardStyle {
        case light, dark
    }

    // MARK: - Sound Categories
    let natureSoundList: [Sound] = [
        Sound(name: "Ocean", fileName: "sea", imageName: "sea"),
        Sound(name: "Forest", fileName: "forest", imageName: "forest"),
        Sound(name: "Campfire", fileName: "fire", imageName: "fire", isPremium: true),
        Sound(name: "Rain", fileName: "rain", imageName: "rain", isPremium: true),
        Sound(name: "Rain with Thunder", fileName: "rain_thunder", imageName: "rain_thunder", isPremium: true),
        Sound(name: "Rain in Forest", fileName: "rain_forest", imageName: "rain_forest", isPremium: true),
        Sound(name: "Rain in Tent", fileName: "rain_tent", imageName: "rain_tent", isPremium: true),
        Sound(name: "Storm", fileName: "storm", imageName: "storm", isPremium: true),
        Sound(name: "Waterfall", fileName: "waterfall", imageName: "waterfall", isPremium: true),
        Sound(name: "Wind", fileName: "wind", imageName: "wind", isPremium: true),
        Sound(name: "Snow Footsteps", fileName: "snow_steps", imageName: "snow_steps", isPremium: true),
        Sound(name: "Stream", fileName: "stream", imageName: "stream", isPremium: true),
        Sound(name: "Jungle", fileName: "jungle", imageName: "jungle", isPremium: true)
    ]

    let sleepSoundList: [Sound] = [
        Sound(name: "White Noise", fileName: "white_noise", imageName: "white_noise"),
        Sound(name: "Crickets at Night", fileName: "crickets", imageName: "crickets"),
        Sound(name: "Rain on Window", fileName: "rain_window", imageName: "rain_window", isPremium: true),
        Sound(name: "Breathing Sound", fileName: "breathing", imageName: "breathing", isPremium: true),
        Sound(name: "Wind in Trees", fileName: "wind_in_trees", imageName: "wind_in_trees", isPremium: true),
        Sound(name: "Fireplace", fileName: "fireplace", imageName: "fireplace", isPremium: true),
        Sound(name: "Highway", fileName: "highway", imageName: "highway", isPremium: true),
        Sound(name: "Heartbeat", fileName: "heartbeat", imageName: "heartbeat", isPremium: true),
        Sound(name: "Brown Noise", fileName: "broun_noise", imageName: "broun_noise", isPremium: true)
    ]

    let ambienceSoundList: [Sound] = [
        Sound(name: "Cafe", fileName: "cafe", imageName: "cafe"),
        Sound(name: "Library", fileName: "library", imageName: "library"),
        Sound(name: "City Night", fileName: "city", imageName: "city", isPremium: true),
        Sound(name: "Train", fileName: "train", imageName: "train", isPremium: true),
        Sound(name: "Office", fileName: "office", imageName: "office", isPremium: true),
        Sound(name: "Foodcourt", fileName: "foodcourt", imageName: "foodcourt", isPremium: true),
        Sound(name: "Fan", fileName: "fan", imageName: "fan", isPremium: true),
        Sound(name: "Aircraft", fileName: "aircraft", imageName: "aircraft", isPremium: true),
        Sound(name: "Train Carriage", fileName: "shum_vnutri_vagona", imageName: "shum_vnutri_vagona", isPremium: true),
        Sound(name: "Circus", fileName: "circus", imageName: "circus", isPremium: true)
    ]

    let meditationSoundList: [Sound] = [
        Sound(name: "Deep Focus", fileName: "deep_focus", imageName: "deep_focus"),
        Sound(name: "Calm Mind", fileName: "calm_mind", imageName: "calm_mind"),
        Sound(name: "Inner Place", fileName: "inner_place", imageName: "inner_place", isPremium: true),
        Sound(name: "Healing Waves", fileName: "healing_waves", imageName: "healing_waves", isPremium: true),
        Sound(name: "Morning Clarity", fileName: "morning_clarity", imageName: "morning_clarity", isPremium: true),
        Sound(name: "Self Love", fileName: "self_love", imageName: "self_love", isPremium: true),
        Sound(name: "Spa Relaxation", fileName: "spa_relaxation", imageName: "spa_relaxation", isPremium: true),
        Sound(name: "Nature Sound", fileName: "nature_sound", imageName: "nature_sound", isPremium: true),
        Sound(name: "Evening Unwind", fileName: "evening", imageName: "evening", isPremium: true),
        Sound(name: "Mantra", fileName: "mantra", imageName: "mantra", isPremium: true)
    ]

    private var allAvailableSounds: [Sound] {
        natureSoundList + sleepSoundList + ambienceSoundList + meditationSoundList
    }

    init() {
        self.isPremiumUnlocked = UserDefaultsManager.shared.getBool(forKey: "isPremiumUnlocked")
        setupAudioSession()
        allSounds = allAvailableSounds
        recentlyPlayed = SoundStorageManager.loadRecent()
        favoriteSounds = SoundStorageManager.loadFavorites()
        observePremiumUnlock()
        observeSettingsReset()
    }

    private func observePremiumUnlock() {
        NotificationCenter.default.addObserver(forName: .premiumUnlocked, object: nil, queue: .main) { [weak self] _ in
            self?.isPremiumUnlocked = true
        }
    }

    private func observeSettingsReset() {
        NotificationCenter.default.addObserver(forName: .settingsDismissed, object: nil, queue: .main) { [weak self] _ in
            self?.isPremiumUnlocked = UserDefaultsManager.shared.getBool(forKey: "isPremiumUnlocked")
            print("🔄 Refetched isPremiumUnlocked: \(self?.isPremiumUnlocked ?? false)")
        }
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
        SoundStorageManager.saveFavorites(favoriteSounds)
    }

    func addToRecentlyPlayed(sound: Sound) {
        if let index = recentlyPlayed.firstIndex(of: sound) {
            recentlyPlayed.remove(at: index)
        }
        recentlyPlayed.insert(sound, at: 0)
        if recentlyPlayed.count > 5 {
            recentlyPlayed = Array(recentlyPlayed.prefix(5))
        }
        SoundStorageManager.saveRecent(recentlyPlayed)
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
