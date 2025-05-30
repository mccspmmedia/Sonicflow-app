import SwiftUI
import GoogleSignIn

struct GoogleSignInButton: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    // Вставь сюда свой client ID (из Google Console)
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
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }

    func handleGoogleSignIn() {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            print("❌ Could not find root view controller")
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("❌ Google Sign In error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user else {
                print("❌ No user returned")
                return
            }

            print("✅ Google Sign In success — email: \(user.profile?.email ?? "No Email")")
            isLoggedIn = true
        }
    }
}
