import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct WelcomeView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            MainTabView() // Показываем полное приложение с меню
        } else {
            VStack(spacing: 32) {
                Spacer()

                // Заголовок и подзаголовок
                VStack(spacing: 12) {
                    Text("Welcome to")
                        .font(.title3)
                        .foregroundColor(.gray)

                    Text("SONIC FLOW")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

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

                // Кнопки входа
                VStack(spacing: 16) {
                    SignInWithAppleButton(
                        onRequest: { request in
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success:
                                isLoggedIn = true
                            case .failure(let error):
                                print("Apple Sign-In failed: \(error.localizedDescription)")
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
                ).ignoresSafeArea()
            )
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
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            if result != nil {
                isLoggedIn = true
            }
        }
    }
}
