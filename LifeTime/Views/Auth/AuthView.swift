import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @State private var viewModel = ViewModel()
    @State private var showEmailSignIn = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
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
                .padding(.horizontal)
                .padding(.top)
                
                
                Button {
                    ///
                } label: {
                    SignInWithAppleButtonViewRepresentable(type: .default, style: .white)
                        .allowsHitTesting(false)
                }
                .frame(height: 55)
                .padding(.horizontal)
                
                Button {
                    Task {
                        await viewModel.anonSignIn()
                    }
                } label: {
                    Text("Позже")
                        .font(.headline)
                        .foregroundStyle(.textSecondary)
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationTitle("Создать аккаунт")
        .sheet(isPresented: $showEmailSignIn) {
            EmailSignInView()
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
