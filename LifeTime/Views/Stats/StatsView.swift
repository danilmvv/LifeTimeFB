import SwiftUI
import Charts

struct StatsView: View {
    @Environment(DBService.self) private var dataService
    
    var body: some View {
        let chartItems: [ChartItem] = dataService.activities.map { activity in
            return ChartItem(title: activity.title, totalTime: dataService.getActivityTotalDuration(activity: activity))
        }
        
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack {
                    Text("Данные за все время")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    Chart(chartItems, id: \.title) { dataItem in
                        SectorMark(
                            angle: .value("Hours", dataItem.totalTime),
                            innerRadius: .ratio(0.6),
                            angularInset: 2.0
                        )
                        .foregroundStyle(by: .value("Type", dataItem.title))
                        .cornerRadius(10.0)
                        .annotation(position: .overlay) {
                            Text("\(dataItem.totalTime.formatTime())")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                    .chartBackground { proxy in
                        Text("LifeTime")
                            .font(.headline)
                    }
                    .padding()
                    .padding(.top, -20)
                }
            }
            .navigationTitle("Статистика")
        }
    }
}

#Preview {
    StatsView()
        .environment(DBService())
}
