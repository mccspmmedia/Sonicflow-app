import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear

        // Убираем черный экран в начале
        player.seek(to: .zero)
        player.play()

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Ничего не обновляем — видео уже работает
    }
}
