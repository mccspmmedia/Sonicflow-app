import SwiftUI

struct NewHomeView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @State private var reminderDate: Date = Date()
    @State private var isReminderSet: Bool = false
    @State private var showTimerPopup = false
    @State private var selectedSoundForTimer: Sound? = nil
    @State private var showSettings = false
    @State private var showSubscriptionBanner = false
    @State private var showLoginSheet = false

    var body: some View {
        ZStack {
            VideoBackgroundView()
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Logo Header
                    VStack(spacing: 6) {
                        HStack {
                            // Левая кнопка: Войти
                            Button(action: {
                                showLoginSheet = true
                            }) {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                                    .padding()
                            }

                            Spacer()

                            // Правая кнопка: Настройки
                            Button(action: {
                                showSettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                                    .padding()
                            }
                        }

                        Text("SONIC FLOW")
                            .font(.custom("Didot", size: 36))
                            .foregroundColor(.white)
                            .fontWeight(.semibold)

                        HStack(spacing: 12) {
                            Text("~")
                            Text("NATURE • SLEEP • MEDITATION")
                            Text("~")
                        }
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 60)

                    // MARK: - Reminder Block
                    ReminderBlockView(
                        selectedTime: $reminderDate,
                        isReminderSet: $isReminderSet,
                        setReminder: {
                            NotificationManager.shared.requestAuthorizationIfNeeded { granted in
                                if granted {
                                    NotificationManager.shared.scheduleNotification(
                                        at: reminderDate,
                                        title: "Time to relax",
                                        body: "Take a moment to enjoy peaceful sounds."
                                    )
                                    isReminderSet = true
                                }
                            }
                        },
                        cancelReminder: {
                            NotificationManager.shared.cancelAllNotifications()
                            isReminderSet = false
                        }
                    )

                    // MARK: - Playing Now
                    if let current = soundVM.currentSound {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Playing Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)

                            CompactSoundCardView(
                                sound: current,
                                onTimerTap: {
                                    selectedSoundForTimer = current
                                    showTimerPopup = true
                                },
                                highlightActive: false
                            )
                            .padding(.horizontal, 16)
                        }
                    }

                    // MARK: - Recently Played
                    if !soundVM.recentlyPlayed.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("You heard recently")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)

                            CustomCarousel(items: soundVM.recentlyPlayed) { sound in
                                CompactSoundCardView(
                                    sound: sound,
                                    onTimerTap: {
                                        selectedSoundForTimer = sound
                                        showTimerPopup = true
                                    },
                                    highlightActive: false
                                )
                            }
                        }
                    }

                    // MARK: - Favorites
                    if !soundVM.favoriteSounds.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favorites")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)

                            CustomCarousel(items: soundVM.favoriteSounds) { sound in
                                CompactSoundCardView(
                                    sound: sound,
                                    onTimerTap: {
                                        selectedSoundForTimer = sound
                                        showTimerPopup = true
                                    },
                                    highlightActive: false
                                )
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }

            // MARK: - Subscription Banner
            if showSubscriptionBanner && !StoreKitManager.shared.isPremiumPurchased {
                PurchaseBannerView(showBanner: $showSubscriptionBanner)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .sheet(isPresented: $showTimerPopup) {
            if let _ = selectedSoundForTimer {
                TimerPopupView()
                    .environmentObject(soundVM)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showLoginSheet) {
            LoginSheetView()
        }
        .onAppear {
            scheduleSubscriptionBanner()
        }
    }

    private func scheduleSubscriptionBanner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
            if !StoreKitManager.shared.isPremiumPurchased {
                withAnimation {
                    showSubscriptionBanner = true
                }
            }
        }
    }
}
