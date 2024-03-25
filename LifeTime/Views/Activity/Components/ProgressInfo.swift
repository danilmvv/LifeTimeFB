import SwiftUI

struct ProgressInfo: View {
    @Environment(DBService.self) private var dataService
    
    @Binding var sessionDuration: TimeInterval
    
    var body: some View {
        VStack {
            Text("\((dataService.totalDuration + sessionDuration).formatTime()) / \(dataService.currentActivity?.goal.formatTime() ?? "")")
                .font(.headline)
                .fontWeight(.bold)
                .animation(.none)
            
            switch GoalType(rawValue: dataService.currentActivity?.goalType ?? "") {
            case .daily:
                Text("сегодня")
                    .font(.caption)
                    .fontWeight(.semibold)
            case .monthly:
                Text("в этом месяце")
                    .font(.caption)
                    .fontWeight(.semibold)
            default:
                Text("на этой неделе")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
        .foregroundStyle(.textSecondary)
    }
}

#Preview {
    ProgressInfo(sessionDuration: .constant(21))
        .environment(DBService())
}
