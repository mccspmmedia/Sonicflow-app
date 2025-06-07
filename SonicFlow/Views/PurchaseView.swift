import SwiftUI

struct PurchaseBannerView: View {
    @Binding var showBanner: Bool
    @ObservedObject var storeKit = StoreKitManager.shared
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var showSubscription = false

    var body: some View {
        VStack {
            Spacer()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unlock Premium")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text("Access all sounds and features")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                // ✅ Кнопка "Unlock All" с поддержкой iPad
                Button(action: {
                    showSubscription = true
                }) {
                    Text("Unlock All")
                        .font(.subheadline.bold())
                        .foregroundColor(.black)
                        .frame(minWidth: 100, maxHeight: 50) // ✅ фиксированная высота
                        .padding(.horizontal, 16)
                        .background(Color.white)
                        .cornerRadius(10)
                        .contentShape(Rectangle()) // ✅ активная зона
                }

                // ❌ Кнопка закрытия
                Button(action: {
                    withAnimation {
                        showBanner = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .imageScale(.large)
                        .frame(width: 32, height: 32)
                }
            }
            .padding()
            .background(
                LinearGradient(colors: [Color.blue, Color.purple],
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.bottom, 12)

            // ✅ Подключение экрана подписки
            .sheet(isPresented: $showSubscription) {
                SubscriptionView()
                    .environmentObject(soundVM)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
