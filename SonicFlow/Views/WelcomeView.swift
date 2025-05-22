import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct WelcomeView: View {
    @State private var isLoggedIn = false
    @State private var tapCount = 0

    // ✅ Аргумент для UI-тестов
    var isUITest: Bool {
        CommandLine.arguments.contains("-isUITest")
    }

    var body: some View {
        if isLoggedIn || isUITest {
            MainTabView()
        } else {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 12) {
                    Text("Welcome to")
                        .font(.title3)
                        .foregroundColor(.gray)

                    Text("SONIC FLOW")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .onTapGesture {
                            handleSecretTap()
                        }

                    Text("~  NATURE  •  SLEEP  •  MEDITATION  ~")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)

                    Text("Relax, sleep better and stay focused")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                VStack(spacing: 16) {
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success:
                                NotificationManager.shared.requestAuthorizationIfNeeded { _ in
                                    DispatchQueue.main.async {
                                        isLoggedIn = true
                                    }
                                }
                            case .failure(let error):
                                print("❌ Apple Sign-In failed: \(error.localizedDescription)")
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .frame(height: 45)
                    .cornerRadius(10)

                    GoogleSignInButton(action: handleGoogleSignIn)
                        .frame(height: 45)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Text("By continuing you agree to our Terms and Privacy Policy")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.black, Color.blue.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }

    // MARK: - Секретный вход
    private func handleSecretTap() {
        tapCount += 1
        if tapCount >= 5 {
            isLoggedIn = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            tapCount = 0
        }
    }

    // MARK: - Google Sign In Logic
    func handleGoogleSignIn() {
        let clientID = "657116176614-lm58c8540jfunbuqpqvt7iie3aojlha2.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            print("No root view controller")
            return
        }

        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            if result != nil {
                NotificationManager.shared.requestAuthorizationIfNeeded { _ in
                    DispatchQueue.main.async {
                        isLoggedIn = true
                    }
                }
            }
        }
    }
}
