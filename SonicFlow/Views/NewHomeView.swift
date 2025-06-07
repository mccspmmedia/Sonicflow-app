import SwiftUI

struct NewHomeView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn = false

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
                    // Header (логотип + кнопки)
                    headerView

                    // Напоминание
                    ReminderBlockView(
                        selectedTime: $reminderDate,
                        isReminderSet: $isReminderSet,
                        setReminder: setReminder,
                        cancelReminder: cancelReminder
                    )

                    // Playing Now
                    if let current = soundVM.currentSound {
                        section(title: "Playing Now") {
                            CompactSoundCardView(
                                sound: current,
                                onTimerTap: {
                                    selectedSoundForTimer = current
                                    showTimerPopup = true
                                },
                                highlightActive: false
                            )
                        }
                    }

                    // Recently Played
                    if !soundVM.recentlyPlayed.isEmpty {
                        section(title: "You heard recently") {
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

                    // Favorites
                    if !soundVM.favoriteSounds.isEmpty {
                        section(title: "Favorites") {
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

            // Баннер подписки
            if showSubscriptionBanner && !StoreKitManager.shared.isPremiumPurchased {
                PurchaseBannerView(showBanner: $showSubscriptionBanner)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .sheet(isPresented: $showTimerPopup) {
            if selectedSoundForTimer != nil {
                TimerPopupView().environmentObject(soundVM)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showLoginSheet) {
            LoginSheetView(isPresented: $showLoginSheet)
        }
        .onAppear {
            scheduleSubscriptionBanner()
        }
    }

    private var headerView: some View {
        VStack(spacing: 6) {
            HStack {
                if !isLoggedIn {
                    Button {
                        showLoginSheet = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .padding()
                    }
                }

                Spacer()

                Button {
                    showSettings = true
                } label: {
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
    }

    private func section<Content: View>(title: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)

            content()
                .padding(.horizontal, 16)
        }
    }

    private func setReminder() {
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
    }

    private func cancelReminder() {
        NotificationManager.shared.cancelAllNotifications()
        isReminderSet = false
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
