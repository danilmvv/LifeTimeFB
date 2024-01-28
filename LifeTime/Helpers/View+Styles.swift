import SwiftUI

extension View {
    func customTextStyle() -> some View {
        self
            .font(.headline)
            .bold()
            .foregroundStyle(.textPrimary)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
            }
    }
}
