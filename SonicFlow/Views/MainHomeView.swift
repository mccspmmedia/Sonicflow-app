import SwiftUI

struct MainHomeView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Favorite Sounds")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(soundVM.favoriteSounds) { sound in
                            SoundCardView(sound: sound) {
                                soundVM.toggleSound(sound)
                            }
                        }
                    }

                    if !soundVM.recentlyPlayed.isEmpty {
                        Text("Recently Played")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(soundVM.recentlyPlayed.prefix(5)) { sound in
                                SoundCardView(sound: sound) {
                                    soundVM.toggleSound(sound)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
            .background(Color("DarkBlue").ignoresSafeArea())
        }
    }
}
