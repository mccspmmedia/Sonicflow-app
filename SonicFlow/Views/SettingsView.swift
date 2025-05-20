import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

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
                Button(action: {
                    UserDefaults.standard.removeObject(forKey: "isPremiumUnlocked")
                    NotificationCenter.default.post(name: .settingsDismissed, object: nil)
                    print("🧹 Premium flag reset")
                }) {
                    HStack {
                        Image(systemName: "lock.slash")
                        Text("Reset Premium Access")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
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
    }
}

#Preview {
    SettingsView()
}
