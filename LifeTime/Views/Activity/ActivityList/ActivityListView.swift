import SwiftUI

struct ActivityListView: View {
    @Environment(DBService.self) private var dataService
    @Environment(\.dismiss) var dismiss
    
    @State private var showAddActivityView: Bool = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                Text("Выберите активность")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                
                ScrollView {
                    ForEach(dataService.activities) { activity in
                        ActivityInfoCard(activity: activity)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                print(activity.title)
                                dataService.currentActivity = activity
                                dismiss()
                            }
                    }
                    .transition(.slide)
                    
                    SecondaryAppButton(title: "Новая активность") {
                        showAddActivityView.toggle()
                    }
                    .padding()
                }
                .animation(.easeInOut, value: dataService.activities)
            }
        }
        .fullScreenCover(isPresented: $showAddActivityView, onDismiss: {
            Task {
                do {
                    try await dataService.getData()
                } catch {
                    print(error)
                }
            }
        }) {
            AddActivityView()
        }
    }
}

#Preview {
    ActivityListView()
        .environment(DBService())
}
