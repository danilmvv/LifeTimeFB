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
    ActivityInfoCard(activity: Activity(id: "1", title: "Гитара", dateAdded: "2024-05-14T18:36:00+05:00", totalTime: 23.5, goal: 0.0, goalType: "", goalCompletedCount: 0, color: "#21B44A", notificationsEnabled: false))
}
