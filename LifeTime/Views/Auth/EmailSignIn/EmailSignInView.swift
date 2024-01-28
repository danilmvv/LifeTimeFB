import SwiftUI

struct EmailSignInView: View {
    @State private var viewModel = ViewModel()
    @State private var authService = AuthService.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack {
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                    }
                    
                    AuthTextField(placeholder: "Email", text: $viewModel.email)
                    AuthTextField(placeholder: "Пароль", text: $viewModel.password, isSecure: true)
                    ActionButton(title: "Готово") {
                        Task {
                            if authService.user != nil {
                                print("Link")
                                await viewModel.linkEmail()
                                if authService.user?.isAnonymous == false {
                                    dismiss()
                                }
                            } else {
                                print("SignIn")
                                await viewModel.signIn()
                                if authService.user != nil {
                                    dismiss()
                                } else {
                                    viewModel.errorMessage = "Ошибка!"
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Электронная почта")
        }
    }
}

#Preview {
    NavigationStack {
        EmailSignInView()
    }
}
