import SwiftUI

struct CompactSoundCardView: View {
    let sound: Sound
    var onTimerTap: () -> Void

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
                    .foregroundColor(.white)
                    .font(.headline)

                HStack(spacing: 10) {
                    Button(action: { soundVM.play(sound) }) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.yellow)
                            .clipShape(Circle())
                    }

                    Button(action: { soundVM.pauseCurrentSound() }) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }

                    Button(action: { soundVM.stopAllSounds() }) {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(Circle())
                    }

                    Button(action: {
                        withAnimation {
                            soundVM.toggleFavorite(sound)
                        }
                    }) {
                        Image(systemName: soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.pink)
                            .clipShape(Circle())
                    }

                    Button(action: {
                        onTimerTap()
                    }) {
                        Image(systemName: "timer")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(red: 12/255, green: 14/255, blue: 38/255))
        .cornerRadius(20)
    }
}
