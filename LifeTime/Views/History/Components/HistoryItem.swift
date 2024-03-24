import SwiftUI

struct HistoryItem: View {
    @Environment(DBService.self) private var dataService
    var session: Session
    
    private var activityDictionary: [String: Activity] {
        Dictionary(uniqueKeysWithValues: dataService.activities.map { ($0.id, $0) })
    }
    
    private func getActivityTitle(session: Session) -> String {
        activityDictionary[session.activityID]?.title ?? "Неизвестное"
    }
    
    var body: some View {
//        Text(getActivityTitle(session: session))
        HStack {
            VStack(alignment: .leading) {
                Text(getActivityTitle(session: session))
                    .font(.headline)
                Text("\(session.duration.formatTime())")
                    .foregroundColor(.gray)
                    .font(.callout)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(session.startTime) - \(session.endTime)")
                    .font(.headline)
                Text(DateConverter.shared.getReadableDateString(session.dateStarted))
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
        .background(.clear)
    }
}

#Preview {
    HistoryItem(session: Session.default)
        .environment(DBService())
}
