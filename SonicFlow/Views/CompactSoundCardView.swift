import SwiftUI

struct CompactSoundCardView: View {
    let sound: Sound
    var onTimerTap: () -> Void
    var isDarkStyle: Bool = true
    var highlightActive: Bool = true

    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var showSubscription = false

    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .topTrailing) {
                Image(sound.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                if sound.isPremium && !soundVM.isPremiumUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                        .offset(x: -4, y: 4)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(sound.name)
                    .foregroundColor(isDarkStyle ? .white : .black)
                    .font(.subheadline.bold())

                HStack(spacing: 10) {
                    iconButton("play.fill", color: .yellow) {
                        handlePremiumAccess {
                            soundVM.play(sound)
                        }
                    }
                    iconButton("pause.fill", color: .blue) {
                        soundVM.pauseCurrentSound()
                    }
                    iconButton("stop.fill", color: .red) {
                        soundVM.stopAllSounds()
                    }
                    iconButton(soundVM.favoriteSounds.contains(sound) ? "heart.fill" : "heart", color: .pink) {
                        handlePremiumAccess {
                            withAnimation {
                                soundVM.toggleFavorite(sound)
                            }
                        }
                    }
                    iconButton("timer", color: .orange) {
                        handlePremiumAccess {
                            onTimerTap()
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(cardBackground)
        .cornerRadius(16)
        .shadow(color: isDarkStyle ? .clear : Color.black.opacity(0.05), radius: 4, x: 0, y: 4)
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
                .environmentObject(soundVM)
        }
    }

    // MARK: - Background
    private var cardBackground: some View {
        Group {
            if highlightActive && sound.id == soundVM.currentSound?.id {
                Color.blue.opacity(0.15)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue, lineWidth: 1))
            } else {
                isDarkStyle
                ? Color(red: 12/255, green: 14/255, blue: 38/255)
                : Color.white
            }
        }
    }

    // MARK: - Button Builder
    private func iconButton(_ systemName: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(isDarkStyle ? .white : .black)
                .padding(6)
                .background(color.opacity(isDarkStyle ? 0.7 : 0.15))
                .clipShape(Circle())
        }
    }

    // MARK: - Premium logic
    private func handlePremiumAccess(_ action: () -> Void) {
        if sound.isPremium && !soundVM.isPremiumUnlocked {
            showSubscription = true
        } else {
            action()
        }
    }
}
