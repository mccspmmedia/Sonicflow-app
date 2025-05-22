import Foundation
import StoreKit

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    @Published var isPremiumPurchased: Bool = false

    private let premiumProductID = "sonicflow.premium"
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
            products = try await Product.products(for: [premiumProductID])
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
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await unlockPremium()
                    try? await AppStore.sync()
                } else {
                    print("❌ Purchase not verified")
                }
            case .userCancelled:
                print("⚠️ Purchase cancelled by user")
            default:
                print("⚠️ Purchase failed or pending")
            }
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Check active subscription status
    func checkPremiumStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == premiumProductID {
                await unlockPremium()
                return
            }
        }

        isPremiumPurchased = UserDefaults.standard.bool(forKey: "isPremiumUnlocked")
    }

    // MARK: - Unlock and notify
    func unlockPremium() async {
        isPremiumPurchased = true
        UserDefaults.standard.set(true, forKey: "isPremiumUnlocked")
        NotificationCenter.default.post(name: .premiumUnlocked, object: nil)
    }
}

extension Notification.Name {
    static let premiumUnlocked = Notification.Name("premiumUnlocked")
}
