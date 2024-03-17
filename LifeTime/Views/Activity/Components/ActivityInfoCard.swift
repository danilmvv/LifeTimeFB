import SwiftUI

struct ActivityInfoCard: View {
    var activity: Activity
    
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
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.fromHexString(activity.color))
        }
    }
}

#Preview {
    ActivityInfoCard(activity: Activity.default)
}
