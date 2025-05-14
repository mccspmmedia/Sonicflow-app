import SwiftUI

struct NatureView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var selectedSoundForTimer: Sound?

    var body: some View {
        ZStack {
            // 🔧 Чуть более тёмный светло-серый фон
            Color(red: 235/255, green: 235/255, blue: 235/255)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Nature Sounds")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding(.top)

                    VStack(spacing: 16) {
                        ForEach(soundVM.natureSoundList) { sound in
                            SoundCardView(sound: sound, onTimerTap: {
                                selectedSoundForTimer = sound
                            })
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
