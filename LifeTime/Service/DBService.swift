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
    
    //MARK: Progress functions
    
    private func getProgress(activity: Activity, duration: TimeInterval) -> Double {
        let totalDuration = duration
        let progress = totalDuration / activity.goal
        
        //        String(format: "%.2f%%", progress * 100)
        return progress
    }
    
    private func getTotalDuration(activity: Activity) -> TimeInterval {
        let filteredSessions = filterSessionsByGoalType(activity: activity)
        let totalDuration = filteredSessions.reduce(0) { $0 + $1.duration }
        
        return totalDuration
    }
    
    private func filterSessionsByGoalType(activity: Activity) -> [Session] {
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
    
    //MARK: Data functions
    
    @MainActor
    func getData() async throws {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        // Download Sessions
        try await updateCollection(uID: uID, collectionName: "sessions", loadingState: &sessionsLoadingState, data: &sessions, sortKeyPath: \Session.dateStarted)
        
        // Download Activities
        try await updateCollection(uID: uID, collectionName: "activities", loadingState: &activitiesLoadingState, data: &activities, sortKeyPath: \Activity.dateAdded)
    }
    
    private func updateCollection<T: Codable & Identifiable>(uID: String, collectionName: String, loadingState: inout LoadingState, data: inout [T], sortKeyPath: KeyPath<T, String>) async throws {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(uID).collection(collectionName)
        
        loadingState = .loading
        let snapshot = try await collectionRef.getDocuments()
        let downloadedData: [T] = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        
        data = downloadedData.sorted { $0[keyPath: sortKeyPath] > $1[keyPath: sortKeyPath] }
        loadingState = .fetched
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
    
    func deleteSession(id: String) {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uID)
            .collection("sessions")
            .document(id)
            .delete{ [weak self] error in
                if let error = error {
                    print("Error deleting session: \(error.localizedDescription)")
                } else {
                    self?.sessions.removeAll { $0.id == id }
                    print("Session deleted successfully")
                }
            }
    }
}
