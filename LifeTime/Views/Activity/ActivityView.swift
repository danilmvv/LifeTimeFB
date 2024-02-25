import SwiftUI

struct ActivityView: View {
    @State private var viewModel = ViewModel()
    let activity: Activity = Activity(id: "", title: "", dateAdded: "", totalTime: 0.0, goal: 0.0, goalType: "", goalCompleted: 0, color: "")
    
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
                    
                    Text("\(viewModel.elapsedTime.toHours(decimals: 3)) ч.")
                        .padding(.top)
                    
                    Spacer()
                    ActivitySelector(activity: Activity(id: "", title: "Activity", dateAdded: "", totalTime: 0.0, goal: 0.0, goalType: "", goalCompleted: 0, color: "#2ED157"))
                        .padding()
                }
            }
        }
    }
}


#Preview {
    ActivityView()
}
