import SwiftUI

enum Tab: String {
    case activity = "Активность"
    case charts = "Статистика"
    case history = "Журнал"
    case settings = "Настройки"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .activity:
            Image(systemName: "clock")
        case .charts:
            Image(systemName: "chart.bar.xaxis")
        case .history:
            Image(systemName: "list.clipboard")
        case .settings:
            Image(systemName: "gearshape")
        }
    }
}

struct ContentView: View {
    @State private var authService = AuthService.shared
    @State private var activeTab: Tab = .activity
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            NavigationStack {
                if authService.user != nil {
                    TabView(selection: $activeTab) {
                        ActivityView()
                            .tag(Tab.activity)
                            .tabItem { Tab.activity.tabContent }
                        
                        SettingsView()
                            .tag(Tab.settings)
                            .tabItem { Tab.settings.tabContent }
                    }
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
