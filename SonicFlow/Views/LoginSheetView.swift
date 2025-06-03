import SwiftUI

struct LoginSheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("Sign in to unlock more features")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)

            // Apple Sign In
            AppleSignInButton()
                .frame(height: 50)
                .padding(.horizontal)

            // Google Sign In
            GoogleSignInButton()
                .frame(height: 50)
                .padding(.horizontal)

            Button("Close") {
                dismiss()
            }
            .foregroundColor(.white.opacity(0.7))
            .padding(.top, 16)

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
