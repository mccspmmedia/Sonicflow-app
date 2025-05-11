import SwiftUI

struct WelcomeView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            NewHomeView() // заменили на новую домашнюю вьюшку
        } else {
            VStack(spacing: 32) {
                Spacer()

                // Логотип и текст
                VStack(spacing: 12) {
                    Text("Welcome to")
                        .font(.title3)
                        .foregroundColor(.gray)

                    Text("SonicFlow")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)

                    Text("Relax, sleep better and stay focused.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Кнопки входа
                VStack(spacing: 16) {
                    Button(action: {
                        isLoggedIn = true
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Sign in with Apple")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    Button(action: {
                        isLoggedIn = true
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Sign in with Google")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Text("By continuing you agree to our **Terms** and **Privacy**")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.black, Color.blue.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
}
