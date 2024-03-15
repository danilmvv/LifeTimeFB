import SwiftUI

enum Day: String, CaseIterable, Codable {
    case Monday = "ПН"
    case Tuesday = "ВТ"
    case Wednesday = "СР"
    case Thursday = "ЧТ"
    case Friday = "ПТ"
    case Saturday = "СБ"
    case Sunday = "ВС"
}

struct DaysPicker: View {
    @Binding var selectedDays: [Day]
    
    var body: some View {
        HStack {
            ForEach(Day.allCases, id: \.self) { day in
                Text(day.rawValue)
                    .fontWeight(.bold)
                    .foregroundStyle(selectedDays.contains(day) ? .appAccent : .textPrimary)
                    .frame(width: 42, height: 42)
                    .background {
                        selectedDays.contains(day)
                        ? Color.appAccent.opacity(0.1).clipShape(Circle())
                        : Color.backgroundSecondary.clipShape(Circle())
                    }
                    .onTapGesture {
                        if selectedDays.contains(day) {
                            selectedDays.removeAll(where: {$0 == day})
                        } else {
                            selectedDays.append(day)
                        }
                    }
            }
        }
    }
}

#Preview {
    DaysPicker(selectedDays: .constant([Day.Monday, Day.Friday]))
}
