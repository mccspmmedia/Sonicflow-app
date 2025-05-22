import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storeKit = StoreKitManager.shared
    @State private var isProcessing = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Unlock All Sounds")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)

            Text("Get full access to all premium sounds for better sleep, focus and relaxation.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal)

            VStack(spacing: 12) {
                Label("Unlimited premium sound access", systemImage: "lock.open.fill")
                Label("Add any sound to Favorites", systemImage: "heart.fill")
                Label("Use timer on all sounds", systemImage: "timer")
            }
            .foregroundColor(.white)
            .padding()

            if isProcessing {
                ProgressView().tint(.white)
            } else {
                VStack(spacing: 12) {
                    // Кнопка подписки
                    Button(action: {
                        Task {
                            isProcessing = true
                            await storeKit.purchasePremium()
                            isProcessing = false
                            if storeKit.isPremiumPurchased {
                                dismiss()
                            }
                        }
                    }) {
                        Text("Subscribe for $9.99 / month")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }

                    // Кнопка восстановления покупки
                    RestorePurchaseButton(isProcessing: $isProcessing) {
                        dismiss()
                    }
                }
                .padding(.horizontal)
            }

            Button("Maybe later") {
                dismiss()
            }
            .foregroundColor(.white.opacity(0.8))

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
        )
    }
}

#Preview {
    SubscriptionView()
}
