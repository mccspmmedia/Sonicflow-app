import SwiftUI

@main
struct SonicFlowApp: App {
    @StateObject private var soundVM = SoundPlayerViewModel()
    @StateObject private var videoVM = AppVideoViewModel()

    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "DarkBlue")
        UITabBar.appearance().backgroundColor = UIColor(named: "DarkBlue")
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

// ✅ Превью (используется только в SwiftUI Preview Canvas)
#Preview {
    MainTabView()
        .environmentObject(SoundPlayerViewModel())
        .environmentObject(AppVideoViewModel())
}
