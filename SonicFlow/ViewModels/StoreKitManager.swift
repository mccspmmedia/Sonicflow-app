import Foundation
import StoreKit

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    @Published var isPremiumPurchased: Bool = false
    @Published var products: [Product] = []

    private let premiumProductID = "sonicflow.premium"

    private init() {
        Task {
            await fetchProducts()
            await checkPremiumStatus()
        }
    }

    // MARK: - Загрузка продуктов
    func fetchProducts() async {
        do {
            print("ℹ️ Fetching products from App Store...")
            products = try await Product.products(for: [premiumProductID])
            if let product = products.first {
                print("✅ Product loaded: \(product.displayName)")
            } else {
                print("⚠️ Product not found in the response")
            }
        } catch {
            print("❌ Failed to fetch products: \(error.localizedDescription)")
        }
    }

    // MARK: - Покупка подписки
    func purchasePremium() async {
        guard !products.isEmpty else {
            print("❌ Products are not loaded yet. Try again later.")
            return
        }

        guard let product = products.first(where: { $0.id == premiumProductID }) else {
            print("❌ Premium product not found in list")
            return
        }

        do {
            print("🛒 Attempting to purchase: \(product.displayName)")
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    print("✅ Purchase verified: \(transaction.productID)")
                    await transaction.finish()
                    await unlockPremium()
                    try? await AppStore.sync()
                case .unverified(_, let error):
                    print("❌ Unverified transaction: \(error.localizedDescription)")
                }

            case .pending:
                print("🕒 Purchase is pending approval")

            case .userCancelled:
                print("⚠️ User cancelled the purchase")

            default:
                print("⚠️ Purchase failed or unknown state")
            }

        } catch {
            print("❌ Purchase failed with error: \(error.localizedDescription)")
        }
    }

    // MARK: - Восстановление покупки
    func restorePurchase() async {
        do {
            print("🔁 Restoring purchases...")
            try await AppStore.sync()
            await checkPremiumStatus()
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Проверка статуса подписки
    func checkPremiumStatus() async {
        print("🔍 Checking current entitlements...")

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == premiumProductID {
                print("✅ Premium entitlement found")
                await unlockPremium()
                return
            }
        }

        // fallback на UserDefaults
        let isUnlocked = UserDefaults.standard.bool(forKey: "isPremiumUnlocked")
        isPremiumPurchased = isUnlocked
        print(isUnlocked ? "✅ Premium restored from local storage" : "ℹ️ No premium entitlement found")
    }

    // MARK: - Разблокировка премиума
    func unlockPremium() async {
        isPremiumPurchased = true
        UserDefaults.standard.set(true, forKey: "isPremiumUnlocked")
        NotificationCenter.default.post(name: .premiumUnlocked, object: nil)
        print("🎉 Premium access unlocked")
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let premiumUnlocked = Notification.Name("premiumUnlocked")
}
