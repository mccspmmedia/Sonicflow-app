import Foundation
import StoreKit

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()

    @Published var isPremiumPurchased: Bool = false
    @Published var products: [Product] = []

    private let premiumProductID = "com.sonicflow.premium"

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
                print("⚠️ Product not found in App Store response")
                products = []
            }
        } catch {
            print("❌ Failed to fetch products: \(error.localizedDescription)")
            products = []
        }
    }

    // MARK: - Покупка премиума
    func purchasePremium() async throws {
        guard let product = products.first(where: { $0.id == premiumProductID }) else {
            print("❌ Product not available in loaded list")
            throw StoreKitError.productNotAvailable
        }

        print("🛒 Initiating purchase for: \(product.displayName)")

        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                print("✅ Transaction verified: \(transaction.productID)")
                await transaction.finish()
                await unlockPremium()
                try? await AppStore.sync()

            case .unverified(_, let error):
                print("❌ Unverified transaction: \(error.localizedDescription)")
                throw error
            }

        case .pending:
            print("🕒 Purchase is pending...")
            throw StoreKitError.purchasePending

        case .userCancelled:
            print("⚠️ User cancelled the purchase")
            throw StoreKitError.userCancelled

        @unknown default:
            print("❓ Unknown purchase result")
            throw StoreKitError.unknown
        }
    }

    // MARK: - Восстановление покупки
    func restorePurchase() async {
        do {
            print("🔁 Attempting to restore purchases...")
            try await AppStore.sync()
            await checkPremiumStatus()
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
        }
    }

    // MARK: - Проверка подписки
    func checkPremiumStatus() async {
        print("🔍 Checking current entitlement state...")

        var hasEntitlement = false

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == premiumProductID {
                print("✅ Active entitlement found for \(transaction.productID)")
                hasEntitlement = true
                break
            }
        }

        isPremiumPurchased = hasEntitlement

        if hasEntitlement {
            await unlockPremium()
        } else {
            print("ℹ️ No premium entitlement found. Access is locked.")
            UserDefaults.standard.set(false, forKey: "isPremiumUnlocked")
        }
    }

    // MARK: - Активация премиума
    func unlockPremium() async {
        isPremiumPurchased = true
        UserDefaults.standard.set(true, forKey: "isPremiumUnlocked")
        NotificationCenter.default.post(name: .premiumUnlocked, object: nil)
        print("🎉 Premium access unlocked and saved")
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
            return "The subscription product is not currently available."
        case .purchasePending:
            return "Your purchase is still pending. Please wait."
        case .userCancelled:
            return "The purchase was cancelled."
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }
}

// MARK: - Notification Extension
extension Notification.Name {
    static let premiumUnlocked = Notification.Name("premiumUnlocked")
}
