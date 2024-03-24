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
                    AppButton(title: "Готово") {
                        Task {
                            if authService.authState != .signedOut {
                                print("Link")
                                await viewModel.linkEmail()
                                if authService.authState == .signedIn {
                                    dismiss()
                                } else {
                                    authService.authLoadingState = .failed
                                    print("Linking error")
                                }
                            } else {
                                print("SignIn")
                                await viewModel.signIn()
                                if authService.authState != .signedOut {
                                    dismiss()
                                } else {
                                    viewModel.errorMessage = "Ошибка!"
                                    authService.authLoadingState = .failed
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    
                    if authService.authLoadingState == .loading {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Электронная почта")
        }
    }
}

#Preview {
    EmailSignInView()
}
