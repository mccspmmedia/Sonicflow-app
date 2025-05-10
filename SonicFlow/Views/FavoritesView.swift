import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Favorite Sounds")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top)

                VStack(spacing: 16) {
                    ForEach(soundVM.favoriteSounds) { sound in
                        SoundCardView(sound: sound) {
                            soundVM.playExclusive(sound)
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .animation(.easeInOut, value: soundVM.favoriteSounds)
            }
            .padding()
        }
        .background(Color("DarkBlue").ignoresSafeArea())
    }
}
