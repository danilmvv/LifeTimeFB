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
    
    @MainActor
    func getData() async throws {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        activitiesLoadingState = .loading
        
        let db = Firestore.firestore()
        let dbRef = db.collection("users").document(uID).collection("activities")
        
        let snapshot = try await dbRef.getDocuments()
        
        let downloaded: [Activity] = try snapshot.documents.map { document in
            try document.data(as: Activity.self)
        }
        
        self.activities = downloaded.sorted { $0.dateAdded > $1.dateAdded }
        activitiesLoadingState = .fetched
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
