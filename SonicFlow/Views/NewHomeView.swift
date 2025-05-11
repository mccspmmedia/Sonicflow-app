import SwiftUI
import AVKit
import UserNotifications

struct NewHomeView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel
    @EnvironmentObject var videoVM: AppVideoViewModel

    @AppStorage("reminderTime") private var reminderTime: TimeInterval =
        Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())?.timeIntervalSince1970 ?? Date().timeIntervalSince1970

    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @State private var showReminderModal = false

    private var formattedReminderTime: String {
        let date = Date(timeIntervalSince1970: reminderTime)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    var body: some View {
        ZStack(alignment: .top) {
            VideoBackgroundView(player: videoVM.player)
                .ignoresSafeArea()

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.3),
                    Color.clear,
                    Color("DarkBlue").opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .center, spacing: 24) {

                    VStack(spacing: 4) {
                        Text("Sonic Flow")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Text("Calm · Focus · Sleep")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello, Dmytro 👋")
                            .font(.title2).bold()
                            .foregroundColor(.white)

                        if notificationsEnabled {
                            Text("Relaxation reminder set for \(formattedReminderTime)")
                                .foregroundColor(.white)
                                .font(.subheadline)

                            HStack {
                                Button("Change time") {
                                    showReminderModal = true
                                }
                                .foregroundColor(.blue)

                                Button("Disable reminder") {
                                    NotificationManager.shared.cancelAllNotifications()
                                    notificationsEnabled = false
                                }
                                .foregroundColor(.red)
                            }
                        } else {
                            Text("Enable reminders to relax")
                                .font(.headline)
                                .foregroundColor(.white)

                            Text("Get notified daily to unwind and enjoy calming sounds")
                                .font(.subheadline)
                                .foregroundColor(.white)

                            Button("Set Reminder") {
                                showReminderModal = true
                            }
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.45))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.top, 20)

                    if let current = soundVM.currentSound {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Now Playing")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            SoundCardView(sound: current) {
                                soundVM.playExclusive(current)
                            }
                            .padding()
                            .background(Color.black.opacity(0.45))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                    }

                    if !soundVM.recentlyPlayed.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("You heard recently")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            TabView {
                                ForEach(soundVM.recentlyPlayed) { sound in
                                    SoundCardView(sound: sound) {
                                        soundVM.playExclusive(sound)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.45))
                                    .cornerRadius(16)
                                    .padding(.horizontal, 24)
                                }
                            }
                            .frame(height: 140)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        }
                    }

                    Spacer().padding(.bottom, 32)
                }
            }
        }
        .sheet(isPresented: $showReminderModal) {
            ReminderModalView(
                isPresented: $showReminderModal,
                reminderDate: Binding(
                    get: { Date(timeIntervalSince1970: reminderTime) },
                    set: { reminderTime = $0.timeIntervalSince1970 }
                ),
                notificationsEnabled: $notificationsEnabled,
                title: "Time to relax 🧘",
                bodyText: "Unwind and enjoy calming sounds with Sonic Flow."
            )
        }
    }
}
