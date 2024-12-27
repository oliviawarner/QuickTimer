import SwiftUI

struct ProgressRing: View {
    var progress: CGFloat

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(lineWidth: 10) // Background ring width
                .opacity(0.3)
                .foregroundColor(.blue)

            // Foreground Progress Circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(.green)
                .rotationEffect(Angle(degrees: -90)) // Start at the top
                .animation(.linear, value: progress) // Smooth animation
        }
    }
}
