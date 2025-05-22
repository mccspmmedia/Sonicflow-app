import SwiftUI

struct SoundCardView: View {
    let sound: Sound
    var onTimerTap: () -> Void
    var isDarkStyle: Bool = true

    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var showSubscription = false

    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .topTrailing) {
                Image(sound.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if sound.isPremium && !soundVM.isPremiumUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .offset(x: -5, y: 5)
                        .transition(.scale)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(sound.name)
                    .font(.headline)
                    .foregroundColor(isDarkStyle ? .white : .black)

                HStack(spacing: 12) {
                    controlButton(icon: "play.fill", color: .blue) {
                        handlePremiumAccess {
                            soundVM.play(sound)
                        }
                    }

                    controlButton(icon: "pause.fill", color: .red) {
                        soundVM.pauseCurrentSound()
                    }

                    controlButton(icon: "stop.fill", color: .yellow) {
                        soundVM.stopAllSounds()
                    }

                    controlButton(icon: soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart", color: .pink) {
                        handlePremiumAccess {
                            withAnimation {
                                soundVM.toggleFavorite(sound)
                            }
                        }
                    }

                    controlButton(icon: "timer", color: .orange) {
                        handlePremiumAccess {
                            onTimerTap()
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(soundVM.currentSound?.id == sound.id ? Color.blue.opacity(0.15) : Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(soundVM.currentSound?.id == sound.id ? Color.blue : Color.clear, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
                .environmentObject(soundVM)
        }
    }

    // MARK: - Helper
    private func controlButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(8)
                .background(isDarkStyle ? color.opacity(0.7) : color)
                .clipShape(Circle())
        }
    }

    private func handlePremiumAccess(_ action: () -> Void) {
        if sound.isPremium && !soundVM.isPremiumUnlocked {
            showSubscription = true
        } else {
            action()
        }
    }
}
