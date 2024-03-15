import Foundation
import SwiftUI

import FirebaseAuth
import FirebaseFirestore

extension AddActivityView {
    
    @Observable
    class ViewModel {
        var title: String = ""
        var emoji: String = ""
        var goal: TimeInterval = 0.0
        var goalType: GoalType = .weekly
        var color: Color = Color.fromHexString("#275FF4")
        var notificationsEnabled: Bool = false
        var notificationTime: String = "09:00"
        var notificationDays: [Day] = []
        var showAlert = false
        
        var canSave: Bool {
            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
                return false
            }
            guard goal > 0 else {
                return false
            }
            
            return true
        }
        
        func createActivity() -> Activity {
            let dateFormatter = DateConverter.shared
            
            let newID = UUID().uuidString
            let newActivity = Activity(
                id: newID,
                title: title,
                dateAdded: dateFormatter.getStringFromDate(Date()),
                totalTime: 0,
                goal: goal * 60 * 60,
                goalType: goalType.rawValue,
                goalCompletedCount: 0,
                color: color.toHexString(),
                notificationsEnabled: notificationsEnabled,
                notificationTime: notificationTime,
                notificationDays: notificationDays
            )
            
            return newActivity
        }
    }
}
