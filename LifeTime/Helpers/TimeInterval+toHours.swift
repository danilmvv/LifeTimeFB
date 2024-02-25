import Foundation

extension TimeInterval {
    func toHours(decimals: Int = 1) -> String {
        let hours = self / 3600.0
        return String(format: "%.\(decimals)f", hours)
    }
}
