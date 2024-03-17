import SwiftUI

struct CircularProgressView: View {
    @Binding var currentActivity: Activity?
    @Binding var elapsedTime: TimeInterval
    @Binding var progress: Double
    @Binding var showTime: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20,lineCap: .butt, dash: [2,6]))
                .foregroundStyle(.appWhite)
                .rotationEffect(Angle(degrees: 270.0))
                .opacity(0.2)
            
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt, dash: [2,6]))
                .foregroundStyle(.appWhite)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.spring(), value: progress)
            
            if currentActivity != nil {
                VStack(spacing: 20) {
                    if showTime {
                        FormattedTimeText(time: $elapsedTime)
                            .foregroundStyle(.textPrimary)
                            .transition(.scale)
                    } else {
                        Image(systemName: "play.fill")
                            .foregroundStyle(.textPrimary)
                            .font(.system(size: 96))
                    }
                }
            } else {
                Text("Добавьте активность!")
            }
        }
        .contentShape(Circle())
    }
}


#Preview {
    CircularProgressView(currentActivity: .constant(Activity.default), elapsedTime: .constant(0), progress: .constant(0.1), showTime: .constant(false))
        .frame(width: 320, height: 320)
}
