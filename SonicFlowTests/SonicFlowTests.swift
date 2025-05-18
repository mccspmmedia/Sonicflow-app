import XCTest
@testable import SonicFlow

final class SonicFlowTests: XCTestCase {

    func testToggleFavorite() {
        let viewModel = SoundPlayerViewModel()
        let sound = Sound(name: "Test", fileName: "test", imageName: "test")

        XCTAssertFalse(viewModel.favoriteSounds.contains(sound))
        viewModel.toggleFavorite(sound)
        XCTAssertTrue(viewModel.favoriteSounds.contains(sound))
        viewModel.toggleFavorite(sound)
        XCTAssertFalse(viewModel.favoriteSounds.contains(sound))
    }

    func testAddToRecentlyPlayed() {
        let viewModel = SoundPlayerViewModel()
        let sound = Sound(name: "Test", fileName: "test", imageName: "test")

        viewModel.addToRecentlyPlayed(sound: sound)
        XCTAssertTrue(viewModel.recentlyPlayed.contains(sound))
        XCTAssertEqual(viewModel.recentlyPlayed.first, sound)
    }

    func testStartAndCancelTimer() {
        let viewModel = SoundPlayerViewModel()
        let sound = Sound(name: "Test", fileName: "test", imageName: "test")

        viewModel.play(sound)
        viewModel.startCountdown(minutes: 1)

        XCTAssertTrue(viewModel.isTimerRunning)
        viewModel.cancelCountdown()
        XCTAssertFalse(viewModel.isTimerRunning)
        XCTAssertEqual(viewModel.timeRemaining, 0)
    }

    func testSoundPlaybackLogic() {
        let viewModel = SoundPlayerViewModel()
        let sound = Sound(name: "Test", fileName: "test", imageName: "test")

        viewModel.play(sound)
        XCTAssertEqual(viewModel.currentSound?.id, sound.id)

        viewModel.pauseCurrentSound()
        viewModel.stopAllSounds()
        XCTAssertNil(viewModel.currentSound)
    }
}
