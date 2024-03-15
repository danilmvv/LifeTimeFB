import Foundation

class DateConverter {
    static let shared = DateConverter()
    
    private init() {}
    
    private let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        return formatter
    }()
    
    private let readableFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        
        return formatter
    }()
    
    private let calendar: Calendar = Calendar.current
    
    func getDateFromString(_ dateString: String) -> Date? {
        return isoFormatter.date(from: dateString)
    }
    
    func getStringFromDate(_ date: Date) -> String {
        return isoFormatter.string(from: date)
    }
    
    func getReadableDate(_ date: Date) -> String {
        return readableFormatter.string(from: date)
    }
    
    func getReadableDateString(_ isoString: String) -> String {
        guard let date = getDateFromString(isoString) else {
            return ""
        }
        return getReadableDate(date)
    }
    
    func getTimeString(_ date: Date) -> String {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return "\(hour):\(minute)"
    }
}
