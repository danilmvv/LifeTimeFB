import SwiftUI
import Charts

struct BarChartView: View {
    @Environment(DBService.self) private var dataService
    
    var chartData: [ChartItem] {
        var items: [ChartItem] = []
        items = dataService.activities.map { activity in
            return ChartItem(
                title: activity.title,
                totalTime: dataService.getActivityTotalDuration(activity: activity),
                color: Color.fromHexString(activity.color)
            )
        }
        
        return items
    }
    
    @State private var selectedCount: Double?
    @State private var selectedActivity: ChartItem?
    
    var body: some View {
        VStack {
            Chart(chartData) { activity in
                SectorMark(
                    angle: .value("Time", activity.totalTime),
                    innerRadius: .ratio(0.6),
                    outerRadius: selectedActivity?.title == activity.title ? 165 : 150,
                    angularInset: 3.0
                )
                .cornerRadius(6.0)
                .foregroundStyle(activity.color)
//                .annotation(position: .overlay) {
//                    Text("\(activity.totalTime.formatTime())")
//                        .font(.headline)
//                        .foregroundStyle(.textPrimary)
//                }
            }
            .chartAngleSelection(value: $selectedCount)
            .chartBackground { chartProxy in
                VStack {
                    if selectedActivity != nil {
                        Text(selectedActivity?.title ?? "Неизвестное")
                            .font(.callout)
                            .foregroundStyle(.textSecondary)
                        
                        Text(selectedActivity?.totalTime.formatTime() ?? "")
                    } else {
                        Text("Всего времени")
                            .font(.callout)
                            .foregroundStyle(.textSecondary)
                        
                        Text("\((chartData.reduce(0) { $0 + $1.totalTime }).formatTime())")
                    }
                }
            }
            .onChange(of: selectedCount, { oldValue, newValue in
                if let newValue {
                    withAnimation {
                        getSelectedActivity(value: newValue)
                    }
                }
            })
        }
        .frame(height: 350)
    }
    
    func getSelectedActivity(value: Double) {
        var cumulativeTotal = 0.0
        
        let activity = chartData.first { activity in
            cumulativeTotal += activity.totalTime
            if value <= cumulativeTotal {
                if selectedActivity?.title == activity.title {
                    selectedActivity = nil
                } else {
                    selectedActivity = activity
                }
                return true
            }
            return false
        }
    }
}

#Preview {
    BarChartView()
        .environment(DBService())
}
