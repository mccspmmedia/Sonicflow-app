import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NewHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            NatureView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("Nature")
                }

            SleepView()
                .tabItem {
                    Image(systemName: "moon.zzz.fill")
                    Text("Sleep")
                }

            MeditationView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Meditation")
                }

            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }
        .accentColor(.white)
        .background(Color("DarkBlue").ignoresSafeArea())
    }
}
