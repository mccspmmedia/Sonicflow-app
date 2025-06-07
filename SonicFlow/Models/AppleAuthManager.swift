import Foundation
import AuthenticationServices

class AppleAuthManager {
    static let shared = AppleAuthManager()

    private let userIdKey = "appleAuthorizedUserIdKey"
    private let loginStatusKey = "isLoggedIn"

    /// Проверяет, сохранён ли userID — используется как индикатор входа
    var isSignedIn: Bool {
        UserDefaults.standard.string(forKey: userIdKey) != nil
    }

    /// Сохраняет userID после успешного входа через Apple
    func store(userID: String) {
        UserDefaults.standard.set(userID, forKey: userIdKey)
        UserDefaults.standard.set(true, forKey: loginStatusKey)
        print("📦 Saved Apple User ID: \(userID)")
    }

    /// Проверяет состояние авторизации Apple ID и сбрасывает статус при недействительности
    func checkCredentialStateAndUpdateStatus() {
        guard let userID = UserDefaults.standard.string(forKey: userIdKey) else {
            print("ℹ️ No saved Apple user ID found")
            setLoggedOut()
            return
        }

        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userID) { state, _ in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    print("✅ Apple credential still valid")
                    break // ничего не делаем
                case .revoked, .notFound:
                    print("⚠️ Apple credential revoked or not found")
                    self.setLoggedOut()
                default:
                    print("ℹ️ Apple credential state: \(state.rawValue)")
                    self.setLoggedOut()
                }
            }
        }
    }

    /// Версия метода с ручной обработкой (используется в MainTabView)
    func checkCredentialState(completion: @escaping (ASAuthorizationAppleIDProvider.CredentialState) -> Void) {
        guard let userID = UserDefaults.standard.string(forKey: userIdKey) else {
            completion(.notFound)
            return
        }

        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userID) { state, _ in
            DispatchQueue.main.async {
                completion(state)
            }
        }
    }

    /// Принудительный выход
    func signOut() {
        setLoggedOut()
        print("👋 Apple User ID and login status removed")
    }

    /// Полное удаление аккаунта
    func deleteAccount() {
        signOut()
        // Здесь можно добавить запрос на сервер для удаления данных, если нужно
    }

    /// Сброс всех данных входа
    private func setLoggedOut() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.set(false, forKey: loginStatusKey)
        NotificationCenter.default.post(name: .didLogOut, object: nil)
    }
}

// Уведомление при выходе (если нужно использовать)
extension Notification.Name {
    static let didLogOut = Notification.Name("didLogOut")
}
