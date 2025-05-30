import SwiftUI
import GoogleSignIn

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

            Text("Manage your app preferences and reset premium access if needed.")
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
            ).ignoresSafeArea()
        )
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteAccount()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete your account and all data?")
        }
    }

    func deleteAccount() {
        // ✅ Google Sign Out
        GIDSignIn.sharedInstance.signOut()

        // ✅ Apple Sign Out (если авторизация через Apple используется)
        AppleAuthManager.shared.signOut()

        // ✅ Очистка всех пользовательских данных
        UserProfileManager.shared.clear()
        SoundStorageManager.deleteAll()
        UserDefaultsManager.shared.clearAll()

        // ✅ Обновление состояния авторизации
        isLoggedIn = false
        NotificationCenter.default.post(name: .didRequestSignOut, object: nil)

        print("🗑️ Account deleted and user signed out")
        dismiss()
    }
}
