import SwiftUI

struct ActivityListView: View {
    @Binding var selectedIndex: Int
    var activities: [Activity]
    
    @Environment(\.dismiss) var dismiss
    @State private var showAddActivityView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    ForEach(0..<activities.count, id: \.self) { index in
                        ActivityInfoCard(activity: activities[index])
                            .padding(.horizontal)
                            .onTapGesture {
                                self.selectedIndex = index
                                dismiss()
                            }
                    }
                    SecondaryAppButton(title: "Новая активность") {
                        showAddActivityView.toggle()
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding(.top)
                .navigationTitle("Выберите активность")
                .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(isPresented: $showAddActivityView){
                AddActivityView()
            }
        }
    }
}

#Preview {
    let previewActivities: [Activity] = [
        Activity(id: "1", title: "Гитара", dateAdded: "15 Января 2024", totalTime: 0.0, goal: 0.0, goalType: "", goalCompleted: 0, color: "#21B44A"),
        Activity(id: "2", title: "Pet-проект", dateAdded: "15 Января 2024", totalTime: 0, goal: 0, goalType: "", goalCompleted: 0, color: "#275FF4"),
        Activity(id: "3", title: "Чтение", dateAdded: "15 Января 2024", totalTime: 0, goal: 0, goalType: "", goalCompleted: 0, color: "#B92D5D")
    ]
    
    return ActivityListView(selectedIndex: .constant(0), activities: previewActivities)
}
