import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Meditation Sounds")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top)

                VStack(spacing: 16) {
                    ForEach(soundVM.meditationSoundList) { sound in
                        SoundCardView(sound: sound) {
                            soundVM.playExclusive(sound)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color("DarkBlue").ignoresSafeArea())
        .onAppear {
            soundVM.appendSoundsIfNeeded(soundVM.meditationSoundList)
        }
    }
}
