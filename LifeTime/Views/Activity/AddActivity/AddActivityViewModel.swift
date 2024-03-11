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
        var color: Color = Color.blue
        var notificationsEnabled: Bool = false
        var notificationTime: String = "09:00"
        var notificationDays: [Day] = []
        var showAlert = false
    }
}
