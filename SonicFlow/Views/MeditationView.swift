import SwiftUI

struct MeditationView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var selectedSoundForTimer: Sound?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Meditation Sounds")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(.top)

                VStack(spacing: 24) {
                    ForEach(soundVM.meditationSoundList) { sound in
                        SoundCardView(sound: sound, onTimerTap: {
                            selectedSoundForTimer = sound
                        })
                        .background(
                            Color(red: 12/255, green: 14/255, blue: 38/255).opacity(0.8)
                        )
                        .cornerRadius(20)
                        .shadow(color: Color.white.opacity(0.15), radius: 6, x: 0, y: 6)
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding()
        }
        .background(Color("DarkBlue").ignoresSafeArea())
        .sheet(item: $selectedSoundForTimer) { _ in
            TimerPopupView()
                .environmentObject(soundVM)
        }
    }
}
