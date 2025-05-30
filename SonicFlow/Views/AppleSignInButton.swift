import SwiftUI
import AuthenticationServices

struct AppleSignInButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleAuthorizationAppleID), for: .touchUpInside)
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        @AppStorage("isLoggedIn") var isLoggedIn = false

        @objc func handleAuthorizationAppleID() {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            // ✅ НАДЁЖНЫЙ способ для iPhone и iPad:
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                fatalError("❌ presentationAnchor: не найдено активное окно")
            }
            return window
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                print("✅ Успешный вход через Apple")
                isLoggedIn = true
                AppleAuthManager.shared.store(userID: credential.user)
            }
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("❌ Ошибка входа через Apple:", error.localizedDescription)
        }
    }
}
