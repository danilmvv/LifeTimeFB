import SwiftUI

struct ActivityView: View {
    @State private var viewModel = ViewModel()
    @State private var selectedIndex: Int = 0
    let activities: [Activity] = [
        Activity(id: "", title: "Гитара", dateAdded: "15 Января 2024", totalTime: 0.0, goal: 0.0, goalType: "", goalCompleted: 0, color: "#21B44A"),
        Activity(id: "", title: "Pet-проект", dateAdded: "15 Января 2024", totalTime: 0, goal: 0, goalType: "", goalCompleted: 0, color: "#275FF4"),
        Activity(id: "", title: "Чтение", dateAdded: "15 Января 2024", totalTime: 0, goal: 0, goalType: "", goalCompleted: 0, color: "#B92D5D")
    ]
    
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    CircularProgressView(
                        elapsedTime: $viewModel.elapsedTime,
                        progress: .constant(0.42),
                        showTime: $viewModel.isRunning
                    )
                    .frame(width: 320, height: 320)
                    .onTapGesture {
                        withAnimation {
                            viewModel.toggleTimer()
                        }
                    }
                    .sensoryFeedback(.impact(flexibility: .solid), trigger: viewModel.isRunning)
                    
                    Spacer()
                    
                    VStack {
                        Text("17/50 ч.")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("на этой неделе")
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.textSecondary)
                    
                    Spacer()
                    ActivitySelector(selectedIndex: $selectedIndex, activities: activities)
                        .padding(.top)
                        .padding(.bottom, 25)
                        .padding(.horizontal, 25)
                        .onTapGesture {
                            isSheetPresented.toggle()
                        }
                        .sensoryFeedback(.impact(flexibility: .soft), trigger: selectedIndex)
                }
            }
            .navigationTitle("Активность")
            .sheet(isPresented: $isSheetPresented) {
                if activities.isEmpty {
                    AddActivityView()
                } else {
                    ActivityListView(selectedIndex: $selectedIndex, activities: activities)
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}


#Preview {
    ActivityView()
}
