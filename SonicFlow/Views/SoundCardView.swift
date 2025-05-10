// MARK: - SoundCardView.swift

import SwiftUI

struct SoundCardView: View {
    let sound: Sound
    let toggleAction: () -> Void
    @State private var animate = false

    var body: some View {
        VStack(spacing: 10) {
            Image(sound.imageName)
                .resizable()
                .aspectRatio(16/9, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipped()
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )

            HStack {
                Text(sound.name)
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
                Button(action: toggleAction) {
                    Image(systemName: sound.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue.opacity(0.7))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
    }
}
