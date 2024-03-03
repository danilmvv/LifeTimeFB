import SwiftUI

struct AppButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(.accentText)
                .padding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.appAccent)
                }
        }
    }
}

#Preview {
    AppButton(title: "Сохранить") {}
}
