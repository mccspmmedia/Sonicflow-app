import SwiftUI

struct NatureView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Nature Sounds")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top)

                VStack(spacing: 16) {
                    ForEach(soundVM.natureSoundList) { sound in
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
