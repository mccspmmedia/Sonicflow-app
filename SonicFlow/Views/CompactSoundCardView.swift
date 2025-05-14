import SwiftUI

struct CompactSoundCardView: View {
    let sound: Sound
    var onTimerTap: () -> Void
    var isDarkStyle: Bool = true

    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        HStack(spacing: 16) {
            Image(sound.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(sound.name)
                    .foregroundColor(isDarkStyle ? .white : .black)
                    .font(.subheadline.bold())

                HStack(spacing: 10) {
                    iconButton("play.fill", color: .yellow) {
                        soundVM.play(sound)
                    }
                    iconButton("pause.fill", color: .blue) {
                        soundVM.pauseCurrentSound()
                    }
                    iconButton("stop.fill", color: .red) {
                        soundVM.stopAllSounds()
                    }
                    iconButton(soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart", color: .pink) {
                        withAnimation {
                            soundVM.toggleFavorite(sound)
                        }
                    }
                    iconButton("timer", color: .orange) {
                        onTimerTap()
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(isDarkStyle
                    ? Color(red: 12/255, green: 14/255, blue: 38/255)
                    : Color.white)
        .cornerRadius(16)
        .shadow(color: isDarkStyle ? .clear : Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
    }

    @ViewBuilder
    private func iconButton(_ systemName: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(isDarkStyle ? .white : .black)
                .padding(6)
                .background(color.opacity(isDarkStyle ? 0.7 : 0.15))
                .clipShape(Circle())
        }
    }
}
