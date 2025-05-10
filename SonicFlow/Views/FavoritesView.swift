// FavoritesView.swift
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Favorites")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top)

                if soundVM.favoriteSounds.isEmpty {
                    Text("You haven’t added any favorite sounds yet.")
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 40)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(soundVM.favoriteSounds) { sound in
                            SoundCardView(sound: sound) {
                                soundVM.toggleSound(sound)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color("DarkBlue").ignoresSafeArea())
        .onAppear {
            soundVM.appendSoundsIfNeeded(soundVM.favoriteSounds)
        }
    }
}
