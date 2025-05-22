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

                Button(action: {
                    showSubscription = true
                }) {
                    Text("Unlock All")
                        .font(.subheadline.bold())
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    withAnimation {
                        showBanner = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                        .imageScale(.large)
                        .padding(.leading, 8)
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
            .padding(.bottom, 10)
            .sheet(isPresented: $showSubscription) {
                SubscriptionView()
                    .environmentObject(soundVM)
            }
        }
    }
}
