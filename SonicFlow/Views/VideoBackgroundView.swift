import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewControllerRepresentable {
    class Coordinator {
        var observerEnd: NSObjectProtocol?
        var observerResume: NSObjectProtocol?
    }

    private let player: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ocean_background", withExtension: "mp4") else {
            fatalError("❌ Video file 'ocean_background.mp4' not found in bundle.")
        }
        let player = AVPlayer(url: url)
        player.isMuted = true
        player.actionAtItemEnd = .none
        return player
    }()

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear

        // 🔁 Зацикливание видео
        context.coordinator.observerEnd = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            self.player.seek(to: .zero)
            self.player.play()
        }

        // ✅ Возобновление при возвращении в приложение
        context.coordinator.observerResume = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            if self.player.timeControlStatus != .playing {
                self.player.play()
            }
        }

        player.seek(to: .zero)
        player.play()

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No-op
    }

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        uiViewController.player?.pause()
        if let observerEnd = coordinator.observerEnd {
            NotificationCenter.default.removeObserver(observerEnd)
        }
        if let observerResume = coordinator.observerResume {
            NotificationCenter.default.removeObserver(observerResume)
        }
    }
}
