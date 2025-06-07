import SwiftUI

@main
struct SonicFlowApp: App {
    @StateObject private var soundVM = SoundPlayerViewModel()
    @StateObject private var videoVM = AppVideoViewModel()

    init() {
        let darkBlue = UIColor(named: "DarkBlue") ?? .black
        UITabBar.appearance().barTintColor = darkBlue
        UITabBar.appearance().backgroundColor = darkBlue
        UITabBar.appearance().isTranslucent = false
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(soundVM)
                .environmentObject(videoVM)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(SoundPlayerViewModel())
        .environmentObject(AppVideoViewModel())
}
