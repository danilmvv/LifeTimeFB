import SwiftUI

struct HistoryItem: View {
    @Environment(DBService.self) private var dataService
    var title: String
    var session: Session
    
    var body: some View {
//        Text(getActivityTitle(session: session))
        HStack {
            VStack(alignment: .leading) {
                Text(title)
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
    HistoryItem(title: "Неизвестное", session: Session.default)
        .environment(DBService())
}
