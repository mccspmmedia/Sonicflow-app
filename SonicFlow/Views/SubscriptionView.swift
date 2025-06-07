import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var storeKit = StoreKitManager.shared
    @State private var isProcessing = false
    @State private var showError = false
    @State private var errorMessage = ""

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
                    Button {
                        isProcessing = true
                        Task {
                            if storeKit.products.isEmpty {
                                isProcessing = false
                                errorMessage = "Product not available. Please try again later."
                                showError = true
                                return
                            }

                            do {
                                try await storeKit.purchasePremium()
                                isProcessing = false
                                if storeKit.isPremiumPurchased {
                                    dismiss()
                                } else {
                                    errorMessage = "Purchase did not complete."
                                    showError = true
                                }
                            } catch {
                                isProcessing = false
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                        }
                    } label: {
                        Text("Subscribe for $9.99 / month")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50) // ✅ обязательно для iPad
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .disabled(isProcessing || storeKit.products.isEmpty)

                    RestorePurchaseButton(isProcessing: $isProcessing) {
                        dismiss()
                    }
                    .frame(height: 50) // ✅ важно для iPad
                }
                .padding(.horizontal)
            }

            Button("Maybe later") {
                dismiss()
            }
            .foregroundColor(.white.opacity(0.8))

            Text("Subscription auto-renews monthly unless cancelled at least 24 hours before the end of the period. You can manage your subscription in your App Store account settings.")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            HStack(spacing: 24) {
                Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))

                Link("Privacy Policy", destination: URL(string: "https://www.apple.com/legal/privacy/")!)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.top, 16)

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
        .alert("Purchase Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}
