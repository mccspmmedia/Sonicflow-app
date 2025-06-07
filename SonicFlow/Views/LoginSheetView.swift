import SwiftUI

struct LoginSheetView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @Environment(\.dismiss) var dismiss
    @State private var isApplePresented = true
    @State private var isGooglePresented = true

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)

            Text("Sign in to unlock more features")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)

            // 🔐 Apple Sign In
            AppleSignInButton(isPresented: $isApplePresented)
                .frame(height: 50)
                .padding(.horizontal)

            // 🔐 Google Sign In
            GoogleSignInButton(isPresented: $isGooglePresented)
                .frame(height: 50)
                .padding(.horizontal)

            // 🔙 Закрыть без входа
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
