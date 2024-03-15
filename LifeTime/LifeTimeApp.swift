import SwiftUI
import FirebaseCore

@main
struct LifeTimeApp: App {
    @State private var dataService = DBService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environment(dataService)
        }
    }
}
