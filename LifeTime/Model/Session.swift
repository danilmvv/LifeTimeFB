import Foundation

struct Session: Codable, Identifiable {
    let id: String
    var activityID: String
    var activityName: String
    var dateStarted: String
    var startTime: String
    var endTime: String
    var duration: TimeInterval
}
