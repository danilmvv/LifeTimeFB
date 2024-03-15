import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable
class DBService {
    var userID: String?
    var activities: [Activity] = []
    var sessions: [Session] = []
    
    func getData() async throws {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        let db = Firestore.firestore()
        let dbRef = db.collection("users").document(uID).collection("activities")
        
        let snapshot = try await dbRef.getDocuments()
        
        let downloaded: [Activity] = try snapshot.documents.map { document in
            try document.data(as: Activity.self)
        }
        
        self.activities = downloaded.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func addActivity(activity: Activity) async throws {
        guard let uID = AuthService.shared.user?.uid else {
            print("uID not found")
            return
        }
        
        let db = Firestore.firestore()
        let dbRef = db.collection("users").document(uID).collection("activities")
        
        try await dbRef.document(activity.id).setData(activity.asDictionary())
    }
}
