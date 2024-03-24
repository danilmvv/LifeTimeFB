import SwiftUI

struct ToastView: View {
    var message: String
    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundColor(.textPrimary)
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(100)
            .shadow(radius: 4)
    }
}

#Preview {
    ZStack {
        Color.backgroundPrimary
        ToastView(message: "Сохранено!")
    }
}
