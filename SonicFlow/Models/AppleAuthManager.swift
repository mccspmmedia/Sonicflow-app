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

    /// Проверяет состояние авторизации Apple ID через API Apple
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

    /// Удаляет userID и сбрасывает локальную авторизацию
    func signOut() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.set(false, forKey: loginStatusKey)
        print("👋 Apple User ID removed")
    }

    /// Полное удаление аккаунта
    func deleteAccount() {
        signOut()
    }
}
