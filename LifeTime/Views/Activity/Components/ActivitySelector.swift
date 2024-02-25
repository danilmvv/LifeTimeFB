import SwiftUI

struct ActivitySelector: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .padding(.horizontal)
            
            Spacer()
            
            Text(activity.title)
                .padding()
                .foregroundStyle(.primary)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .padding(.horizontal)
        }
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.fromHexString(activity.color))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ActivitySelector(activity: Activity(id: "", title: "Activity", dateAdded: "", totalTime: 0.0, goal: 0.0, goalType: "", goalCompleted: 0, color: "#2ED157"))
}
