import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .frame(maxHeight: 50)
            .foregroundStyle(.primary)
            .fontWeight(.bold)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
            }
    }
}

#Preview {
    CustomTextField(placeholder: "Название", text: .constant(""))
}
