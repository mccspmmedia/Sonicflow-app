import SwiftUI

struct NewHomeView: View {
    @EnvironmentObject var soundVM: SoundPlayerViewModel

    var body: some View {
        ZStack {
            // Фоновое видео
            VideoBackgroundView()
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 24) {
                    // Логотип
                    VStack(spacing: 6) {
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

                    // Приветствие
                    VStack(spacing: 8) {
                        Text("Hello, Dmytro 👋")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Text("Enable reminders to relax")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        Text("Get notified daily to unwind and enjoy calming sounds")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.8))

                        Button(action: {
                            // reminder logic
                        }) {
                            Text("Set Reminder")
                                .foregroundColor(.blue)
                                .bold()
                        }
                    }
                    .padding()
                    .background(Color(red: 12/255, green: 14/255, blue: 38/255).opacity(0.85))
                    .cornerRadius(24)
                    .padding(.horizontal, 24)

                    // Playing Now Block
                    if let current = soundVM.currentSound {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Playing Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)

                            SoundCardView(sound: current) {
                                soundVM.toggleSound(current)
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // Recently Played
                    VStack(alignment: .leading, spacing: 12) {
                        Text("You heard recently")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)

                        ZStack(alignment: .trailing) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(soundVM.recentlyPlayed) { sound in
                                        SoundCardView(sound: sound) {
                                            soundVM.toggleSound(sound)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }

                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.trailing, 8)
                        }
                    }

                    // Favorites
                    if !soundVM.favoriteSounds.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Favorites")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)

                            ZStack(alignment: .trailing) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(soundVM.favoriteSounds) { sound in
                                            SoundCardView(sound: sound) {
                                                soundVM.toggleSound(sound)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.4))
                                    .padding(.trailing, 8)
                            }
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
        }
    }
}
