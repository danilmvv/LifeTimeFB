import Foundation

extension TimeInterval {
    func formatTime(decimals: Int = 1) -> String {
        if self < 3600 {
            let minutes = self / 60.0
            return String(format: "%.0f мин.", minutes)
        } else {
            let hours = self / 3600.0
            return String(format: "%.\(decimals)f ч.", hours)
        }
    }
}
