import SwiftUI

struct SoundCardView: View {
    let sound: Sound
    let toggleAction: () -> Void
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var animate = false

    var body: some View {
        HStack(spacing: 16) {
            // Изображение звука
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
                    Button(action: {
                        soundVM.toggleSound(sound)
                    }) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Circle())
                    }

                    Button(action: {
                        soundVM.stopAllSounds()
                    }) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red.opacity(0.7))
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
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .onAppear {
            animate = true
        }
    }
}
