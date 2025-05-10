import SwiftUI

@main
struct SonicFlowApp: App {
    @StateObject private var soundVM = SoundPlayerViewModel()

    init() {
        // Настройка фона нижнего TabView
        UITabBar.appearance().barTintColor = UIColor(named: "DarkBlue")
        UITabBar.appearance().backgroundColor = UIColor(named: "DarkBlue")
        UITabBar.appearance().isTranslucent = false
    }

    var body: some Scene {
        WindowGroup {
            MainTabView() // Убедись, что ты используешь MainTabView как корневой
                .environmentObject(soundVM)
                .preferredColorScheme(.dark)
        }
    }
}
