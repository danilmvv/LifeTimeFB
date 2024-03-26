import SwiftUI

struct CircularProgressView: View {    
    @Environment(DBService.self) private var dataService
    
    @Binding var sessionDuration: TimeInterval
    @Binding var showTime: Bool
    
    var currentProgress: Double {
        guard let currentActivity = dataService.currentActivity else { return 0 }
        return dataService.goalProgress + sessionDuration / currentActivity.goal
    }
        
    var body: some View {
        @Bindable var dataService = dataService
                
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20,lineCap: .butt, dash: [2,6]))
                .foregroundStyle(.appWhite)
                .rotationEffect(Angle(degrees: 270.0))
                .opacity(0.2)
            
            Circle()
                .trim(from: 0.0, to: min(currentProgress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt, dash: [2,6]))
                .foregroundStyle(.appWhite)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.spring(), value: currentProgress)
            
            VStack(spacing: 20) {
                if showTime {
                    FormattedTimeText(time: $sessionDuration)
                        .foregroundStyle(.textPrimary)
                        .transition(.scale)
                } else {
                    Image(systemName: "play.fill")
                        .foregroundStyle(.textPrimary)
                        .font(.system(size: 96))
//                        .transition(.scale)
                }
            }
        }
        .contentShape(Circle())
    }
}


#Preview {
    CircularProgressView(sessionDuration: .constant(0), showTime: .constant(false))
        .frame(width: 320, height: 320)
        .environment(DBService())
}
