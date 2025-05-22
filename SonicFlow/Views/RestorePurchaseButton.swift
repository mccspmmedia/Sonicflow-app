import SwiftUI
import StoreKit

struct RestorePurchaseButton: View {
    @Binding var isProcessing: Bool
    var onRestoreSuccess: () -> Void

    var body: some View {
        Button(action: {
            Task {
                isProcessing = true
                try? await AppStore.sync() // 🔄 восстановление
                await StoreKitManager.shared.checkPremiumStatus()
                isProcessing = false
                if StoreKitManager.shared.isPremiumPurchased {
                    onRestoreSuccess()
                }
            }
        }) {
            Text("Restore Purchase")
                .font(.subheadline)
                .foregroundColor(.white)
                .underline()
        }
        .disabled(isProcessing)
    }
}
