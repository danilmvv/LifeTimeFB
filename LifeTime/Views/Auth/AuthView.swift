import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @State private var authService = AuthService.shared
    @State private var showEmailSignIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    if authService.authLoadingState == .loading {
                        ProgressView()
                    }
                    
                    Text("Привяжите свою учетную запись, чтобы безопасно сохранить данные в облаке и обеспечить синхронизацию на всех ваших устройствах.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.textSecondary)
                        .padding(.horizontal)
                    
                    Button {
                        showEmailSignIn.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Email")
                        }
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
                    .padding(.top)
                    
                    Button {
                        print("Пока не работает :(")
                    } label: {
                        SignInWithAppleButtonViewRepresentable(type: .default, style: .white)
                            .allowsHitTesting(false)
                    }
                    .frame(height: 50)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            do {
                                try await authService.anonymousSignIn()
                            } catch {
                                authService.authLoadingState = .failed
                                print(error)
                            }
                        }
                    } label: {
                        Text("Позже")
                            .font(.headline)
                            .foregroundStyle(.textSecondary)
                    }
                    .padding(.vertical)
                    
                }
                .padding()
            }
            .navigationTitle("Привязать аккаунт")
            .sheet(isPresented: $showEmailSignIn) {
                EmailSignInView()
            }
        }
    }
}

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

#Preview {
    NavigationStack {
        AuthView()
    }
}
