import SwiftUI

struct AuthTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool?
    
    var body: some View {
        HStack {
            if let isSecure = isSecure, isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .padding()
        .foregroundStyle(.primary)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    AuthTextField(placeholder: "Email", text: .constant(""))
}
