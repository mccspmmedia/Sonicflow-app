import SwiftUI

struct SoundCardView: View {
    let sound: Sound
    let onPlayPause: () -> Void
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        HStack(spacing: 12) {
            Image(sound.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(12)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(sound.name)
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 16) {
                    // Play/Pause
                    Button(action: {
                        withAnimation {
                            onPlayPause()
                        }
                    }) {
                        Image(systemName: sound.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                    }

                    // Favorite
                    Button(action: {
                        withAnimation {
                            soundVM.toggleFavorite(sound)
                        }
                    }) {
                        Image(systemName: soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .font(.title3)
                    }

                    // Timer
                    Button(action: {
                        soundVM.currentSound = sound
                        soundVM.showTimer = true
                    }) {
                        Image(systemName: "timer")
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}
