import SwiftUI

struct ProgressInfo: View {
    @Environment(DBService.self) private var dataService
    @Binding var sessionDuration: TimeInterval
    
    var body: some View {
        VStack {
            Text("\((dataService.currentActivityGoalDuration + sessionDuration).formatTime(showHourUnits: false)) / \(dataService.currentActivity?.goal.formatTime() ?? "0 ч.")")
                .font(.headline)
                .fontWeight(.semibold)
                .animation(.none)
            
            HStack {
                switch GoalType(rawValue: dataService.currentActivity?.goalType ?? "") {
                case .daily:
                    Text("сегодня")
                case .monthly:
                    Text("в этом месяце")
                default:
                    Text("на этой неделе")
                }
            }
            .font(.caption)
            .fontDesign(.rounded)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical, 20)
        .foregroundStyle(.textSecondary)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    ProgressInfo(sessionDuration: .constant(21))
        .environment(DBService())
}
