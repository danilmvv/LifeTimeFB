import Foundation
import SwiftUI

enum GoalType: String, CaseIterable {
    case daily = "в день"
    case weekly = "в неделю"
    case monthly = "в месяц"
}

struct Activity: Codable, Identifiable, Equatable {
    let id: String
    var title: String
    var dateAdded: String
    var goal: TimeInterval
    var goalType: String
    var goalCompletedCount: Int
    var color: String
    var notificationsEnabled: Bool
    var notificationTime: String?
    var notificationDays: [Day]?
    
    var goalInHours: Double {
        get {
            return goal / 3600.0
        }
        set {
            goal = newValue * 3600.0
        }
    }
    
    static let `default` = Activity(id: UUID().uuidString, title: "Чтение", dateAdded: "2024-05-14T18:36:00+05:00", goal: 0, goalType: GoalType.weekly.rawValue, goalCompletedCount: 0, color: "#21B44A", notificationsEnabled: false)
}
