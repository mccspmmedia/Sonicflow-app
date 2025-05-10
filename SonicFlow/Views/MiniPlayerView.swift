import SwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        if let sound = soundVM.currentSound {
            VStack {
                Spacer()

                HStack(spacing: 12) {
                    Image(sound.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        .clipped()

                    VStack(alignment: .leading, spacing: 4) {
                        Text(sound.name)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Play / Pause button
                    Button(action: {
                        soundVM.toggleSound(sound)
                    }) {
                        Image(systemName: sound.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    // Favorite button
                    Button(action: {
                        soundVM.toggleFavorite(sound)
                    }) {
                        Image(systemName: soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .font(.title2)
                    }

                    // Timer button
                    Button(action: {
                        soundVM.showTimer = true
                    }) {
                        Image(systemName: "timer")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                }
                .padding()
                .background(Color("DarkBlue").opacity(0.95))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .shadow(radius: 5)
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: soundVM.currentSound)
            }
        }
    }
}
