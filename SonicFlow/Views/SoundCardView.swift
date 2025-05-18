import SwiftUI

struct SoundCardView: View {
    let sound: Sound
    var onTimerTap: () -> Void
    var isDarkStyle: Bool = true // 🔹 Новый параметр

    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        HStack(spacing: 16) {
            Image(sound.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(sound.name)
                    .foregroundColor(isDarkStyle ? .white : .black)
                    .font(.headline)

                HStack(spacing: 12) {
                    Button(action: {
                        soundVM.play(sound)
                    }) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isDarkStyle ? Color.blue.opacity(0.7) : Color.blue)
                            .clipShape(Circle())
                    }
                    .accessibilityIdentifier("playButton")

                    Button(action: {
                        soundVM.pauseCurrentSound()
                    }) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isDarkStyle ? Color.red.opacity(0.7) : Color.red)
                            .clipShape(Circle())
                    }
                    .accessibilityIdentifier("pauseButton")

                    Button(action: {
                        soundVM.stopAllSounds()
                    }) {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isDarkStyle ? Color.yellow.opacity(0.7) : Color.yellow)
                            .clipShape(Circle())
                    }
                    .accessibilityIdentifier("stopButton")

                    Button(action: {
                        withAnimation {
                            soundVM.toggleFavorite(sound)
                        }
                    }) {
                        Image(systemName: soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isDarkStyle ? Color.pink.opacity(0.7) : Color.pink)
                            .clipShape(Circle())
                    }
                    .accessibilityIdentifier("heartButton")

                    Button(action: {
                        onTimerTap()
                    }) {
                        Image(systemName: "timer")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isDarkStyle ? Color.orange.opacity(0.7) : Color.orange)
                            .clipShape(Circle())
                    }
                    .accessibilityIdentifier("timerButton")
                }
            }

            Spacer()
        }
        .padding()
        .background(isDarkStyle ? Color.white : Color.white)
        .cornerRadius(20)
        .shadow(color: isDarkStyle ? Color.black.opacity(0.05) : Color.black.opacity(0.06), radius: 4, x: 0, y: 4)
    }
}
