import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

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
        // Очистка локальных данных
        UserProfileManager.shared.clear()
        SoundStorageManager.deleteAll()

        // Уведомление о выходе
        NotificationCenter.default.post(name: .didRequestSignOut, object: nil)
        print("🗑️ Account deleted")
    }
}
