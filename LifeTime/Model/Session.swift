import Foundation

struct Session: Codable, Identifiable, Equatable {
    let id: String
    var activityID: String
    var dateStarted: String
    var startTime: String
    var endTime: String
    var duration: TimeInterval
    
    static let `default` = Session(id: "", activityID: "", dateStarted: "2024-05-19T21:39:55+05:00", startTime: "9:05", endTime: "9:35", duration: 1800)
}
