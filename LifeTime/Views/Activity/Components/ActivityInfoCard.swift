import SwiftUI

struct ActivityInfoCard: View {
    @Environment(DBService.self) private var dataService
    
    var activity: Activity
    
    var currentProgress: Double {
        return dataService.goalProgress
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("C \(DateConverter.shared.getReadableDateString(activity.dateAdded))")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            .foregroundStyle(Color.fromHexString(activity.color).isDark ? Color.textPrimary : Color.accentText)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            ProgressBackground(progress: dataService.getProgress(activity: activity), fillColor: Color.fromHexString(activity.color))
        }
    }
}

struct ProgressBackground: View {
    var progress: Double
    var fillColor: Color
    var cornerRadius: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fillColor)
                    .opacity(0.5)
                    .overlay(alignment: .leading) {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(fillColor)
                            .frame(width: geometry.size.width * progress)
                    }
            }
        }
    }
}

#Preview {
    ActivityInfoCard(activity: Activity.default)
        .environment(DBService())
}
