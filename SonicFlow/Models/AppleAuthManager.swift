import Foundation
import AuthenticationServices

class AppleAuthManager {
    static let shared = AppleAuthManager()

    private let userIdKey = "appleAuthorizedUserIdKey"

    /// Сохраняет userID после успешного входа через Apple
    func store(userID: String) {
        UserDefaults.standard.set(userID, forKey: userIdKey)
    }

    /// Проверяет состояние авторизации Apple ID
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
        print("✅ Apple ID локально разлогинен")
    }

    /// Полное удаление аккаунта (если нужно расширить в будущем)
    func deleteAccount() {
        signOut()
    }
}
