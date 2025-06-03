import SwiftUI

struct MainTabView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = true
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            
            // 🏠 Главная (c видеофоном)
            ZStack {
                VideoBackgroundView().ignoresSafeArea()
                NewHomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            // 🍃 Nature
            NatureView()
                .tabItem {
                    Label("Nature", systemImage: "leaf.fill")
                }
                .tag(1)

            // 🌙 Sleep
            SleepView()
                .tabItem {
                    Label("Sleep", systemImage: "moon.fill")
                }
                .tag(2)

            // 🧘 Meditation
            MeditationView()
                .tabItem {
                    Label("Meditation", systemImage: "sparkles")
                }
                .tag(3)

            // 🌆 Ambience
            AmbienceView()
                .tabItem {
                    Label("Ambience", systemImage: "waveform.path.ecg")
                }
                .tag(4)
        }
        .accentColor(.white)
        .onAppear {
            setupTabBarAppearance()
        }
        .fullScreenCover(isPresented: .constant(!isLoggedIn)) {
            LoginSheetView()
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
