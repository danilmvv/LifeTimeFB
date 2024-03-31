import Foundation

extension TimeInterval {
    func formatTime(decimals: Int = 1, showHourUnits: Bool = true) -> String {
        if self < 60 {
            return String(format: "%.0f сек.", self)
        } else if self < 3600 {
            let minutes = self / 60.0
            return String(format: "%.0f мин.", minutes)
        } else {
            let hours = self / 3600.0
            let decimalPart = hours.truncatingRemainder(dividingBy: 1)
            
            if showHourUnits {
                if decimalPart == 0 {
                    return String(format: "%.0f ч.", hours)
                } else {
                    return String(format: "%.\(decimals)f ч.", hours)
                }
            } else {
                if decimalPart == 0 {
                    return String(format: "%.0f", hours)
                } else {
                    return String(format: "%.\(decimals)f", hours)
                }
            }
        }
    }
    
    func toHours(decimalPlaces: Int = 1) -> TimeInterval {
        let hours = self / 3600.0
        return Double(String(format: "%.\(decimalPlaces)f", hours)) ?? 0.0
    }
}
