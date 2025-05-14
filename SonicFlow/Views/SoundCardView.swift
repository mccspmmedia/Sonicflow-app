import SwiftUI

struct SoundCardView: View {
    let sound: Sound
    var onTimerTap: () -> Void

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
                    .foregroundColor(.black)
                    .font(.headline)

                HStack(spacing: 12) {
                    Button(action: {
                        soundVM.play(sound)
                    }) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Circle())
                    }

                    Button(action: {
                        soundVM.pauseCurrentSound()
                    }) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red.opacity(0.7))
                            .clipShape(Circle())
                    }

                    Button(action: {
                        soundVM.stopAllSounds()
                    }) {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.yellow.opacity(0.7))
                            .clipShape(Circle())
                    }

                    Button(action: {
                        withAnimation {
                            soundVM.toggleFavorite(sound)
                        }
                    }) {
                        Image(systemName: soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.pink.opacity(0.7))
                            .clipShape(Circle())
                    }

                    Button(action: {
                        onTimerTap()
                    }) {
                        Image(systemName: "timer")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.orange.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
    }
}
