import SwiftUI

struct ContentView: View {
    @State private var authService = AuthService.shared
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            NavigationStack {
                if authService.user != nil {
                    ActivityView()
                } else {
                    AuthView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
