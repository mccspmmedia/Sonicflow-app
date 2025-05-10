import SwiftUI
import AVKit

struct NewHomeView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    // Видео-плеер для фона
    private let oceanPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ocean", withExtension: "mp4") else {
            fatalError("Video file not found")
        }
        let player = AVPlayer(url: url)
        player.isMuted = true
        player.actionAtItemEnd = .none

        // Зацикливание
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }

        player.play()
        return player
    }()

    var body: some View {
        ZStack(alignment: .top) {
            // Видео фон
            VideoPlayerView(player: oceanPlayer)
                .frame(height: 300)
                .ignoresSafeArea()

            // Градиент поверх видео
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.2),
                    Color("DarkBlue")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Основной контент
            ScrollView {
                VStack(spacing: 24) {
                    // Заголовок
                    VStack(spacing: 4) {
                        Text("Sonic Flow")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        Text("Calm • Focus • Sleep")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)

                    // Приветствие и новости
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Guten Tag, Dmytro")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Update v1.2 Released!")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("New timer, fade out, background playback")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color("DarkBlue").opacity(0.9))
                    .cornerRadius(24)
                    .padding(.horizontal)

                    // Последние прослушанные
                    if !soundVM.recentlyPlayed.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("You heard recently")
                                .font(.headline)
                                .foregroundColor(.white)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(soundVM.recentlyPlayed.prefix(10)) { sound in
                                        SoundPreviewCard(title: sound.name, imageName: sound.imageName)
                                            .onTapGesture {
                                                soundVM.stopAllSounds()
                                                soundVM.appendSoundsIfNeeded([sound])
                                                soundVM.toggleSound(sound)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    // Избранные
                    if !soundVM.favoriteSounds.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favorites")
                                .font(.headline)
                                .foregroundColor(.white)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(soundVM.favoriteSounds) { sound in
                                        SoundPreviewCard(title: sound.name, imageName: sound.imageName)
                                            .onTapGesture {
                                                soundVM.stopAllSounds()
                                                soundVM.appendSoundsIfNeeded([sound])
                                                soundVM.toggleSound(sound)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    Spacer()
                }
                .padding(.bottom, 32)
            }

            // Мини-плеер снизу
            VStack {
                Spacer()
                MiniPlayerView()
            }
        }
    }
}

struct SoundPreviewCard: View {
    let title: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 120)
                .clipped()
                .cornerRadius(12)

            Text(title)
                .foregroundColor(.white)
                .font(.caption)
        }
        .frame(width: 140)
    }
}
