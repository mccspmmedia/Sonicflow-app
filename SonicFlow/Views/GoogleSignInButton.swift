import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @Binding var isPresented: Bool

    private let clientID = "657116176614-lm58c8540jfunbuqpqvt7iie3aojlha2.apps.googleusercontent.com"

    var body: some View {
        Button(action: handleGoogleSignIn) {
            HStack {
                Image(systemName: "globe")
                    .font(.headline)
                Text("Sign in with Google")
                    .fontWeight(.medium)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, minHeight: 50) // ✅ критично для iPad
            .background(Color.white)
            .cornerRadius(12)
        }
    }

    private func handleGoogleSignIn() {
        guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            print("❌ Could not find root view controller")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("❌ Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                print("❌ No user returned")
                return
            }

            print("✅ Google Sign-In success — email: \(user.profile?.email ?? "Unknown")")
            isLoggedIn = true
            isPresented = false
        }
    }
}
