import SwiftUI

struct SoundCardView: View {
    let sound: Sound

    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var animate = false

    var body: some View {
        HStack(spacing: 16) {
            Image(sound.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(sound.name)
                    .foregroundColor(.white)
                    .font(.headline)

                HStack(spacing: 12) {
                    // ▶️ Play
                    Button(action: {
                        soundVM.play(sound)
                    }) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Circle())
                    }

                    // ⏸ Pause
                    Button(action: {
                        soundVM.pauseCurrentSound()
                    }) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red.opacity(0.7))
                            .clipShape(Circle())
                    }

                    // ⏹ Stop
                    Button(action: {
                        soundVM.stopAllSounds()
                    }) {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }

                    // ❤️ Favorite
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

                    // ⏲ Timer
                    Button(action: {
                        soundVM.showTimer = true
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
        .background(Color(red: 12/255, green: 14/255, blue: 38/255).opacity(0.85))
        .cornerRadius(20)
    }
}
