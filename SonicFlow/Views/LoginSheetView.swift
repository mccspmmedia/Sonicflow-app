import SwiftUI

struct LoginSheetView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Sign in to unlock more features")
                .font(.headline)
                .multilineTextAlignment(.center)

            AppleSignInButton()
                .frame(height: 45)

            GoogleSignInButton()
                .frame(height: 45)

            Spacer()
        }
        .padding()
    }
}
