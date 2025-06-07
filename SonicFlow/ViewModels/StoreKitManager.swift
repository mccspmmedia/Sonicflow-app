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
            let storeProducts = try await Product.products(for: [premiumProductID])
            if let product = storeProducts.first {
                products = [product]
                print("✅ Product loaded: \(product.displayName)")
            } else {
                print("⚠️ Product not found in StoreKit list")
            }
        } catch {
            print("❌ Failed to fetch products: \(error.localizedDescription)")
        }
    }

    // MARK: - Покупка премиума
    func purchasePremium() async throws {
        guard let product = products.first(where: { $0.id == premiumProductID }) else {
            throw StoreKitError.productNotAvailable
        }

        print("🛒 Attempting purchase for: \(product.displayName)")
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                print("✅ Transaction verified for \(transaction.productID)")
                await transaction.finish()
                await unlockPremium()
                try? await AppStore.sync()
            case .unverified(_, let error):
                print("❌ Unverified purchase: \(error.localizedDescription)")
                throw error
            }

        case .pending:
            print("🕒 Purchase pending")
            throw StoreKitError.purchasePending

        case .userCancelled:
            print("⚠️ Purchase cancelled by user")
            throw StoreKitError.userCancelled

        default:
            print("⚠️ Unknown purchase result")
            throw StoreKitError.unknown
        }
    }

    // MARK: - Восстановление
    func restorePurchase() async {
        do {
            print("🔁 Attempting to restore...")
            try await AppStore.sync()
            await checkPremiumStatus()
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Проверка текущей подписки
    func checkPremiumStatus() async {
        print("🔍 Checking entitlement...")

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == premiumProductID {
                print("✅ Active subscription found")
                await unlockPremium()
                return
            }
        }

        // fallback на UserDefaults
        let saved = UserDefaults.standard.bool(forKey: "isPremiumUnlocked")
        isPremiumPurchased = saved
        print(saved ? "✅ Premium restored from local" : "ℹ️ No valid entitlement")
    }

    // MARK: - Разблокировка
    func unlockPremium() async {
        isPremiumPurchased = true
        UserDefaults.standard.set(true, forKey: "isPremiumUnlocked")
        NotificationCenter.default.post(name: .premiumUnlocked, object: nil)
        print("🎉 Premium unlocked and stored locally")
    }
}

// MARK: - Ошибки
enum StoreKitError: LocalizedError {
    case productNotAvailable
    case purchasePending
    case userCancelled
    case unknown

    var errorDescription: String? {
        switch self {
        case .productNotAvailable:
            return "Product is not available."
        case .purchasePending:
            return "Purchase is pending. Please wait."
        case .userCancelled:
            return "Purchase cancelled."
        case .unknown:
            return "Unknown error occurred."
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let premiumUnlocked = Notification.Name("premiumUnlocked")
}
