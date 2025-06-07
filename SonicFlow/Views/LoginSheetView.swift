import SwiftUI

struct LoginSheetView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)

            // Заголовок
            Text("Sign in to unlock more features")
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal)

            // 🔐 Apple Sign-In
            AppleSignInButton(isPresented: $isPresented)
                .frame(height: 50)
                .padding(.horizontal)

            // 🔐 Google Sign-In
            GoogleSignInButton(isPresented: $isPresented)
                .frame(height: 50)
                .padding(.horizontal)

            // ❌ Manual Close
            Button("Close") {
                isPresented = false
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
        .onAppear {
            // Актуализируем статус авторизации Apple при каждом показе
            AppleAuthManager.shared.checkCredentialStateAndUpdateStatus()
        }
        .onChange(of: isLoggedIn) { loggedIn in
            if loggedIn {
                isPresented = false
            }
        }
    }
}
