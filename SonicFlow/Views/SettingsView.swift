import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)

            Text("App Settings")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundColor(.white)

            Text("Manage your preferences and reset premium access if needed.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal)

            VStack(spacing: 16) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Account")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            Button(action: {
                dismiss()
            }) {
                Text("Close")
                    .foregroundColor(.white)
                    .underline()
            }

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to permanently delete your account and all data?")
        }
    }

    func deleteAccount() {
        // 🔐 Google Sign Out
        if GIDSignIn.sharedInstance.currentUser != nil {
            GIDSignIn.sharedInstance.signOut()
            print("🔓 Signed out from Google")
        }

        // 🍎 Apple Sign Out (если использовалась авторизация Apple)
        if AppleAuthManager.shared.isSignedIn {
            AppleAuthManager.shared.signOut()
            print("🔓 Signed out from Apple")
        }

        // 🗑️ Очистка всех данных
        UserProfileManager.shared.clear()
        SoundStorageManager.deleteAll()
        UserDefaultsManager.shared.clearAll()

        // ❌ Завершение сессии
        isLoggedIn = false
        NotificationCenter.default.post(name: .didRequestSignOut, object: nil)

        print("🧼 Account and data deleted. User signed out.")
        dismiss()
    }
}
