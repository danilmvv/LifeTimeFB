import SwiftUI

struct ActivityInfoCard: View {
    var activity: Activity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(activity.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("C \(activity.dateAdded)")
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
    ActivityInfoCard(activity: Activity(id: "1", title: "Гитара", dateAdded: "15 Января 2024", totalTime: 23.5, goal: 0.0, goalType: "", goalCompleted: 0, color: "#21B44A"))
}
