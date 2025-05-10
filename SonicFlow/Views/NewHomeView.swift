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

            // Градиентный затемнённый эффект внизу видео
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.black.opacity(0.8), location: 0.0),
                    .init(color: Color.black.opacity(0.4), location: 0.5),
                    .init(color: Color.clear, location: 1.0)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 300)
            .ignoresSafeArea()

            // Основной контент
            ScrollView {
                VStack(spacing: 24) {
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

                    if !soundVM.recentlyPlayed.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("You heard recently")
                                .font(.headline)
                                .foregroundColor(.white)

                            TabView {
                                ForEach(soundVM.recentlyPlayed.prefix(5)) { sound in
                                    SoundCardView(sound: sound) {
                                        soundVM.playExclusive(sound)
                                    }
                                    .padding(.horizontal, 32)
                                }
                            }
                            .frame(height: 140)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        }
                    }

                    if !soundVM.favoriteSounds.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favorites")
                                .font(.headline)
                                .foregroundColor(.white)

                            TabView {
                                ForEach(soundVM.favoriteSounds.prefix(5)) { sound in
                                    SoundCardView(sound: sound) {
                                        soundVM.playExclusive(sound)
                                    }
                                    .padding(.horizontal, 32)
                                }
                            }
                            .frame(height: 140)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        }
                    }

                    Spacer()
                }
                .padding(.bottom, 32)
            }
        }
    }
}
