import SwiftUI
import AuthenticationServices

struct MainTabView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var selectedTab = 0

    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $selectedTab) {

                // 🏠 Home with video background
                ZStack {
                    VideoBackgroundView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()

                    NewHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

                NatureView()
                    .tabItem { Label("Nature", systemImage: "leaf.fill") }
                    .tag(1)

                SleepView()
                    .tabItem { Label("Sleep", systemImage: "moon.fill") }
                    .tag(2)

                MeditationView()
                    .tabItem { Label("Meditation", systemImage: "sparkles") }
                    .tag(3)

                AmbienceView()
                    .tabItem { Label("Ambience", systemImage: "waveform.path.ecg") }
                    .tag(4)
            }
            .accentColor(.white)
            .onAppear {
                setupTabBarAppearance()

                // ✅ Проверка валидности Apple ID — без вызова LoginSheet
                AppleAuthManager.shared.checkCredentialState { state in
                    if state != .authorized {
                        isLoggedIn = false
                    }
                }
            }
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "DarkBlue") ?? UIColor.systemBlue
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
