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

    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            if authService.authState != .signedOut {
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
                .tint(.appWhite)
                .task {
                    do {
                        try await dataService.fetchData()
                        dataService.currentActivity = dataService.activities.first
                    } catch {
                        print(error)
                    }
                }
            } else {
                AuthView()
            }
        }
        .overlay {
            if showSplash {
                withAnimation {
                    SplashView()
                        .transition(.opacity)
                }
            }
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(DBService())
}
