import SwiftUI

struct ActivitySelector: View {
    @Binding var selectedIndex: Int
    var activities: [Activity]
    
    var body: some View {
        HStack {
            if !activities.isEmpty {
                Button {
                    withAnimation {
                        selectPrevious()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(.horizontal)
                }
                
                Spacer()
                
                Text(activities[selectedIndex].title)
                    .padding()
                    .foregroundStyle(.primary)
                    .font(.headline)
                    .animation(.none, value: selectedIndex)
                
                Spacer()
                
                Button {
                    withAnimation {
                        selectNext()
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .padding(.horizontal)
                }
            } else {
                Text("Создать активность")
                    .padding()
                    .foregroundStyle(.primary)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    activities.isEmpty
                    ? Color.backgroundSecondary
                    : Color.fromHexString(activities[selectedIndex].color)
                )
        }
    }
    
    func selectPrevious() {
        if selectedIndex == 0 {
            selectedIndex = activities.count - 1
        } else {
            selectedIndex -= 1
        }
    }
    
    func selectNext() {
        if selectedIndex == activities.count - 1 {
            selectedIndex = 0
        } else {
            selectedIndex += 1
        }
    }
}

#Preview {
    let previewActivities: [Activity] = [
        Activity(id: "", title: "Гитара", dateAdded: "", totalTime: 0.0, goal: 0.0, goalType: "", goalCompleted: 0, color: "#21B44A"),
        Activity(id: "", title: "Pet-проект", dateAdded: "", totalTime: 0, goal: 0, goalType: "", goalCompleted: 0, color: "#275FF4"),
        Activity(id: "", title: "Чтение", dateAdded: "", totalTime: 0, goal: 0, goalType: "", goalCompleted: 0, color: "#B92D5D")
    ]
    
    return ActivitySelector(selectedIndex: .constant(0), activities: previewActivities)
}
