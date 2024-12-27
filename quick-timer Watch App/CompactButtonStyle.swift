import SwiftUI

struct CompactButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.footnote) // Smaller font size for buttons
            .padding(6) // Small padding
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // Visual press effect
    }
}
