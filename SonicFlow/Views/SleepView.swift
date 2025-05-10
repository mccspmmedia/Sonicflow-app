import SwiftUI

struct SleepView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sleep Sounds")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top)

                VStack(spacing: 16) {
                    ForEach(soundVM.sleepSoundList) { sound in
                        SoundCardView(sound: sound) {
                            soundVM.playExclusive(sound)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color("DarkBlue").ignoresSafeArea())
    }
}
