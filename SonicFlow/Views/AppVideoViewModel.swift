import Foundation
import AVKit
import Combine

class AppVideoViewModel: ObservableObject {
    let player: AVPlayer

    init() {
        // Загружаем видео ocean.mp4 из основного бандла
        guard let url = Bundle.main.url(forResource: "ocean_background", withExtension: "mp4") else {
            fatalError("Video file 'ocean_background.mp4' not found in bundle.")
        }

        // Инициализируем плеер
        self.player = AVPlayer(url: url)
        self.player.isMuted = true
        self.player.actionAtItemEnd = .none

        // Зацикливаем видео
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.player.seek(to: .zero)
            self?.player.play()
        }

        // Запуск воспроизведения
        player.play()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
