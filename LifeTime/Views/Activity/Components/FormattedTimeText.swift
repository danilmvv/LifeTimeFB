import SwiftUI

struct FormattedTimeText: View {
    @Binding var time: TimeInterval
    
    var body: some View {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        if hours > 0 {
            Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
                .font(.system(size: 48, design: .monospaced))
        } else {
            Text(String(format: "%02d:%02d", minutes, seconds))
                .font(.system(size: 64, design: .monospaced))
        }
    }
}

#Preview {
    FormattedTimeText(time: .constant(140))
}
