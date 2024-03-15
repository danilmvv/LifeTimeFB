import SwiftUI

enum Tab: String {
    case activity = "Активность"
    case stats = "Статистика"
    case history = "Журнал"
    case settings = "Настройки"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .activity:
            Image(systemName: "clock")
        case .stats:
            Image(systemName: "chart.bar.xaxis")
        case .history:
            Image(systemName: "list.clipboard")
        case .settings:
            Image(systemName: "gearshape")
        }
    }
}

struct ContentView: View {
    @Environment(DBService.self) private var dataService
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

                        StatsView()
                            .tag(Tab.stats)
                            .tabItem { Tab.stats.tabContent }

                        
                        HistoryView()
                            .tag(Tab.history)
                            .tabItem { Tab.history.tabContent }

                        SettingsView()
                            .tag(Tab.settings)
                            .tabItem { Tab.settings.tabContent }
                    }
                    .task {
                        do {
                            try await dataService.getData()
                        } catch {
                            print(error)
                        }
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
