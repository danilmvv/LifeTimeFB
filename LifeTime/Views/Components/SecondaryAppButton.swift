import SwiftUI

struct SecondaryAppButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(.textPrimary)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.thinMaterial)
                }
        }
    }
}

#Preview {
    SecondaryAppButton(title: "Кнопка") {}
}
