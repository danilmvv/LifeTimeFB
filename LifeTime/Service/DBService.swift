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
