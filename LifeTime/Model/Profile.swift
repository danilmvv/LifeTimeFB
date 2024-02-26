import Foundation

struct Profile: Codable {
    let id: String
    let email: String?
    let joined: TimeInterval
}
