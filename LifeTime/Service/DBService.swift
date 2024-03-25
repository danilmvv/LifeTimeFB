import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable
class DBService {
    var userID: String?
    
    var activities: [Activity] = []
    var sessions: [Session] = []
    var currentActivity: Activity?
    
    var activitiesLoadingState: LoadingState = .fetched
    var sessionsLoadingState: LoadingState = .fetched
    
    var totalDuration: TimeInterval {
        guard let currentActivity = currentActivity else { return 0 }
        
        let totalDuration = getTotalDuration(activity: currentActivity)
        return totalDuration
    }
    
    var goalProgress: Double {
        guard let currentActivity = currentActivity else { return 0 }
        
        if totalDuration > 0 {
            let progress = getProgress(activity: currentActivity, duration: totalDuration)
            return progress
        }
        
        return 0
    }
    
    private func getProgress(activity: Activity, duration: TimeInterval) -> Double {
        let totalDuration = duration
        let progress = totalDuration / activity.goal
        
        //        String(format: "%.2f%%", progress * 100)
        return progress
    }
    
    private func getTotalDuration(activity: Activity) -> TimeInterval {
        let filteredSessions = filterSessions(activity: activity)
        let totalDuration = filteredSessions.reduce(0) { $0 + $1.duration }
        
        return totalDuration
    }
    
    private func filterSessions(activity: Activity) -> [Session] {
        let today = Date()
        let calendar = Calendar.current
        
        let currentActivitySessions = sessions.filter { $0.activityID == activity.id }
        var filteredSessions: [Session] = []
        
        switch GoalType(rawValue: activity.goalType) {
        case .daily:
            let startOfDay = calendar.startOfDay(for: today)
            let endOfDay = calendar.date(byAdding: .second, value: 86399, to: startOfDay)!
            filteredSessions = currentActivitySessions.filter {
                formatDate($0.dateStarted) >= startOfDay && formatDate($0.dateStarted) <= endOfDay
            }
            
        case .weekly:
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
            let startOfWeek = calendar.date(from: components)!
            let endOfWeek = calendar.date(byAdding: .second, value: 604799, to: startOfWeek)!
            
            filteredSessions = currentActivitySessions.filter {
                calendar.isDate(formatDate($0.dateStarted), inSameDayAs: startOfWeek)
                || (formatDate($0.dateStarted) > startOfWeek && formatDate($0.dateStarted) <= endOfWeek) }
            
        case .monthly:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            filteredSessions = currentActivitySessions.filter {
                formatDate($0.dateStarted) >= startOfMonth && formatDate($0.dateStarted) <= endOfMonth
            }
        default:
            filteredSessions = currentActivitySessions
        }
        
        return filteredSessions
    }
    
    private func formatDate(_ date: String) -> Date {
        let formatted = DateConverter.shared.getDateFromString(date) ?? Date()
        
        return formatted
    }
    
    @MainActor
    func getData() async throws {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        let db = Firestore.firestore()
        let activitiesRef = db.collection("users").document(uID).collection("activities")
        let sessionsRef = db.collection("users").document(uID).collection("sessions")
        
        // Activities download
        activitiesLoadingState = .loading
        let activitiesSnapshot = try await activitiesRef.getDocuments()
        let downloadedActivities: [Activity] = try activitiesSnapshot.documents.map { document in
            try document.data(as: Activity.self)
        }
        
        self.activities = downloadedActivities.sorted { $0.dateAdded > $1.dateAdded }
        activitiesLoadingState = .fetched
        
        // Sessions download
        sessionsLoadingState = .loading
        let sessionsSnapshot = try await sessionsRef.getDocuments()
        let downloadedSessions: [Session] = try sessionsSnapshot.documents.map { document in
            try document.data(as: Session.self)
        }
        
        self.sessions = downloadedSessions.sorted { $0.dateStarted > $1.dateStarted }
        sessionsLoadingState = .fetched
    }
    
    @MainActor
    func addActivity(activity: Activity) async throws {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        let db = Firestore.firestore()
        let dbRef = db.collection("users").document(uID).collection("activities")
        
        try await dbRef.document(activity.id).setData(activity.asDictionary())
    }
    
    @MainActor
    func saveSession(session: Session) async throws {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        let db = Firestore.firestore()
        let dbRef = db.collection("users").document(uID).collection("sessions")
        
        try await dbRef.document(session.id).setData(session.asDictionary())
    }
}
