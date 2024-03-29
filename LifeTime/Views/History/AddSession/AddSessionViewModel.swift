import Foundation

extension AddSessionView {
    
    @Observable
    class ViewModel {
        var selectedDate = Date()
        var startTime = Date().addingTimeInterval(-1800)
        var endTime = Date()
        
        func createSession(activity: Activity) -> Session {
            let dateFormatter = DateConverter.shared
            let calendar = Calendar.current
            
            let startDate = calendar.date(
                bySettingHour: calendar.component(.hour, from: startTime),
                minute: calendar.component(.minute, from: startTime),
                second: 0,
                of: selectedDate
            ) ?? selectedDate
            
            let endDate = calendar.date(
                bySettingHour: calendar.component(.hour, from: endTime),
                minute: calendar.component(.minute, from: endTime),
                second: 0,
                of: selectedDate
            ) ?? selectedDate
            
            let duration = endDate.timeIntervalSince(startDate)
            
            let newID = UUID().uuidString
            let newSession = Session(
                id: newID,
                activityID: activity.id,
                dateStarted: dateFormatter.getStringFromDate(startDate),
                startTime: dateFormatter.getTimeString(startDate),
                endTime: dateFormatter.getTimeString(endDate),
                duration: duration
            )
            
            return newSession
        }
    }
}
