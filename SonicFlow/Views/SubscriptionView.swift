import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isPurchasing = false

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

            if isPurchasing {
                ProgressView()
                    .tint(.white)
            } else {
                Button(action: {
                    Task {
                        isPurchasing = true
                        await StoreKitManager.shared.purchasePremium()
                        isPurchasing = false
                        dismiss()
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
                .padding(.horizontal)
            }

            Button("Maybe later") {
                dismiss()
            }
            .foregroundColor(.white)
            .underline()

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

// ✅ SwiftUI Preview
#Preview {
    SubscriptionView()
        .environmentObject(SoundPlayerViewModel())
}
