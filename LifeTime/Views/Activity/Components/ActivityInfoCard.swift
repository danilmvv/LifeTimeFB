import SwiftUI

struct ActivityInfoCard: View {
    @Environment(DBService.self) private var dataService
    var activity: Activity
    
    var duration: TimeInterval {
        return dataService.getActivityGoalDuration(activity: activity)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
//                Text("C \(DateConverter.shared.getReadableDateString(activity.dateAdded))")
//                    .font(.subheadline)
//                    .fontWeight(.light)
                
                HStack {
                    Text("\(duration.formatTime(showHourUnits: false))/\(activity.goal.formatTime())")
                    
                    switch GoalType(rawValue: activity.goalType) {
                    case .daily:
                        Text("сегодня")
                    case .monthly:
                        Text("в этом месяце")
                    default:
                        Text("на этой неделе")
                    }
                }
                .font(.footnote)
            }
            .fontDesign(.rounded)
            .foregroundStyle(Color.fromHexString(activity.color).isDark ? Color.textPrimary : Color.accentText)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            ProgressBackground(progress: dataService.getActivityProgress(activity: activity), fillColor: Color.fromHexString(activity.color))
        }
    }
}

struct ProgressBackground: View {
    var progress: Double
    var fillColor: Color
    var cornerRadius: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(fillColor)
                    .opacity(0.5)
                
                Rectangle()
                    .fill(fillColor)
                    .frame(width: geometry.size.width * min(progress, 1))
                    .clipped()
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    ActivityInfoCard(activity: Activity.default)
        .environment(DBService())
}
