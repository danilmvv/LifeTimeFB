import SwiftUI

struct StatsView: View {
    @Environment(DBService.self) private var dataService
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack {
                    BarChartView()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Статистика")
        }
    }
}

#Preview {
    StatsView()
        .environment(DBService())
}
