import SwiftUI
import AuthenticationServices

struct AppleSignInButton: UIViewRepresentable {
    @Binding var isPresented: Bool

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .white)
        button.addTarget(
            context.coordinator,
            action: #selector(Coordinator.handleAuthorizationAppleID),
            for: .touchUpInside
        )
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }

    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        @AppStorage("isLoggedIn") var isLoggedIn = false
        private var isPresented: Binding<Bool>

        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
        }

        @objc func handleAuthorizationAppleID() {
            print("👉 Apple Sign-In button tapped")

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow } ?? UIWindow()
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                print("⚠️ Invalid credential type")
                return
            }

            print("✅ Apple Sign-In successful. UserID: \(credential.user)")
            AppleAuthManager.shared.store(userID: credential.user)
            isLoggedIn = true
            isPresented.wrappedValue = false
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("❌ Apple Sign-In failed: \(error.localizedDescription)")
        }
    }
}
