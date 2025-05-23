import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ZStack {
                VideoBackgroundView()
                    .ignoresSafeArea()
                NewHomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)

            NatureView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Nature")
                }
                .tag(1)

            SleepView()
                .tabItem {
                    Image(systemName: "moon.fill")
                    Text("Sleep")
                }
                .tag(2)

            MeditationView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Meditation")
                }
                .tag(3)

            AmbienceView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Ambience")
                }
                .tag(4)
        }
        .accentColor(.white)
        .onAppear {
            setupTabBarAppearance()
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "DarkBlue")

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
