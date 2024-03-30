import SwiftUI

struct TotalTimeInfo: View {
    @Environment(DBService.self) private var dataService
    @Binding var sessionDuration: TimeInterval
    
    var body: some View {
        VStack {
            Text("\((dataService.totalActivityDuration + sessionDuration).formatTime())")
                .font(.headline)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .animation(.none)
            
            Text("Всего")
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical, 20)
        .foregroundStyle(.textSecondary)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    TotalTimeInfo(sessionDuration: .constant(20))
        .environment(DBService())
}
