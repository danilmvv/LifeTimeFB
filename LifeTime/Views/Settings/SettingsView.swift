import SwiftUI

struct SettingsView: View {
    @State private var viewModel = ViewModel()
    @State private var authService = AuthService.shared
    @State private var showEmailSignIn = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                if authService.user?.isAnonymous == true {
                    Button {
                        showEmailSignIn.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Привязать эл. почту")
                        }
                        .customTextStyle()
                    }
                    .padding()
                    
                    //TODO: Удалить кнопку
                    Button {
                        Task {
                            authService.signOut()
                        }
                    } label: {
                        Text("Выйти")
                            .foregroundStyle(Color.appRed)
                    }
                } else {
                    Text(authService.user?.email ?? "")
                        .customTextStyle()
                        .padding()
                    
                    Button {
                        authService.signOut()
                    } label: {
                        Text("Выйти")
                            .foregroundStyle(Color.appRed)
                    }
                }
                
                Spacer()
            }
            
        }
        .navigationTitle("Настройки")
        .sheet(isPresented: $showEmailSignIn) {
            EmailSignInView()
        }
    }
}


#Preview {
    NavigationStack {
        SettingsView()
    }
}
