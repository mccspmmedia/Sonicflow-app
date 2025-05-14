import SwiftUI

struct AmbienceView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var selectedSoundForTimer: Sound?

    var body: some View {
        ZStack {
            // Светло-серый фон
            Color(red: 235/255, green: 235/255, blue: 235/255)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Ambience Sounds")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding(.top)

                    VStack(spacing: 16) {
                        ForEach(soundVM.ambienceSoundList) { sound in
                            SoundCardView(sound: sound, onTimerTap: {
                                selectedSoundForTimer = sound
                            }, isDarkStyle: false) // Светлый стиль
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .sheet(item: $selectedSoundForTimer) { _ in
            TimerPopupView()
                .environmentObject(soundVM)
        }
    }
}
