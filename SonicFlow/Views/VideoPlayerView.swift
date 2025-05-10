import SwiftUI
import AVKit

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView(player: player)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}

// MARK: - Custom UIView with AVPlayerLayer
class PlayerUIView: UIView {
    private var playerLayer: AVPlayerLayer?
    private var observer: NSObjectProtocol?

    init(player: AVPlayer) {
        super.init(frame: .zero)
        backgroundColor = .clear

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(layer)
        self.playerLayer = layer

        player.isMuted = true
        player.actionAtItemEnd = .none
        player.play()

        observer = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
