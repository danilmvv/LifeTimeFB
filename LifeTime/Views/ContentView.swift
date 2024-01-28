import SwiftUI

struct ContentView: View {
    @State private var authService = AuthService.shared
    
    var body: some View {
        ZStack {
            NavigationStack {
                if authService.user != nil {
                    SettingsView()
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
