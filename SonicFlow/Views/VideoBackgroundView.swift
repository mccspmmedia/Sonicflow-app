import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewControllerRepresentable {
    class Coordinator {
        var observer: NSObjectProtocol?
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

        context.coordinator.observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            self.player.seek(to: .zero)
            self.player.play()
        }

        player.seek(to: .zero)
        player.play()

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No update needed
    }

    static func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        uiViewController.player?.pause()
        if let observer = coordinator.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
