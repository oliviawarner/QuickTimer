import SwiftUI

struct ConfettiView: View {
    @State var animate = false // Controls animation state

    var body: some View {
        ZStack {
            ForEach(0..<50) { i in // Create 50 confetti pieces
                ConfettiShape()
                    .foregroundColor(randomColor())
                    .frame(width: 10, height: 10) // Confetti size
                    .offset(x: animate ? randomXOffset() : 0,
                            y: animate ? randomYOffset() : 0)
                    .opacity(animate ? 0 : 1) // Fade out confetti
                    .animation(Animation.easeOut(duration: 2).delay(Double(i) * 0.02), value: animate)
            }
        }
        .onAppear {
            animate.toggle() // Start the animation
        }
    }

    // Generate a random color
    private func randomColor() -> Color {
        Color(hue: .random(in: 0...1), saturation: 1, brightness: 1)
    }

    // Generate a random X offset
    private func randomXOffset() -> CGFloat {
        CGFloat.random(in: -100...100)
    }

    // Generate a random Y offset
    private func randomYOffset() -> CGFloat {
        CGFloat.random(in: 100...300)
    }
}

// Custom shape for confetti pieces
struct ConfettiShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addRect(rect) // Simple rectangular confetti
        }
    }
}
