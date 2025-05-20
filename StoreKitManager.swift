import Foundation
import StoreKit

class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    @Published var isPremiumPurchased: Bool = false

    private let premiumProductID = "com.sonicflow.app.premium"
    private var products: [Product] = []

    private init() {
        Task {
            await fetchProducts()
            await checkPremiumStatus()
        }
    }

    // MARK: - Fetch products from App Store
    func fetchProducts() async {
        do {
            let storeProducts = try await Product.products(for: [premiumProductID])
            products = storeProducts
        } catch {
            print("❌ Failed to fetch products: \(error.localizedDescription)")
        }
    }

    // MARK: - Purchase logic
    func purchasePremium() async {
        guard let product = products.first(where: { $0.id == premiumProductID }) else {
            print("❌ Premium product not found")
            return
        }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                switch verificationResult {
                case .verified:
                    await unlockPremium()
                case .unverified:
                    print("❌ Purchase result unverified")
                }
            case .userCancelled:
                print("⚠️ Purchase cancelled by user")
            default:
                print("⚠️ Purchase not completed")
            }
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Check active entitlements
    func checkPremiumStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == premiumProductID {
                await unlockPremium()
                return
            }
        }

        // Fallback if no entitlement found but previously unlocked
        await MainActor.run {
            self.isPremiumPurchased = UserDefaults.standard.bool(forKey: "isPremiumUnlocked")
        }
    }

    // MARK: - Unlock and notify
    @MainActor
    func unlockPremium() {
        isPremiumPurchased = true
        UserDefaults.standard.set(true, forKey: "isPremiumUnlocked")
        print("✅ Premium access unlocked")

        NotificationCenter.default.post(name: .premiumUnlocked, object: nil)
    }
}

// MARK: - Notification name
extension Notification.Name {
    static let premiumUnlocked = Notification.Name("premiumUnlocked")
}
