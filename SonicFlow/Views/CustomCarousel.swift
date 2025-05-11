import SwiftUI

struct CustomCarousel<Content: View, T: Identifiable>: View {
    let items: [T]
    let content: (T) -> Content

    @State private var currentIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                HStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: geometry.size.width * 0.85)
                            .padding(.horizontal, geometry.size.width * 0.075)
                    }
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(currentIndex) * geometry.size.width)
                .animation(.easeInOut(duration: 0.3), value: currentIndex)

                // Left Arrow
                if currentIndex > 0 {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 24, weight: .semibold))
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .position(x: 20, y: geometry.size.height / 2)
                }

                // Right Arrow
                if currentIndex < items.count - 1 {
                    Button(action: {
                        if currentIndex < items.count - 1 {
                            currentIndex += 1
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 24, weight: .semibold))
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .position(x: geometry.size.width - 20, y: geometry.size.height / 2)
                }
            }
        }
        .frame(height: 110)
    }
}
