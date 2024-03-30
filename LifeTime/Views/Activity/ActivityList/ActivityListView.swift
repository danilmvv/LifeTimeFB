import SwiftUI

struct ActivityListView: View {
    @Environment(DBService.self) private var dataService
    @Environment(\.dismiss) var dismiss
    
    @State private var showAddActivityView: Bool = false
    @State private var activityToDelete: Activity?
    @State private var confirmationShown = false
    
    @State private var activityToEdit: Activity?
    @State private var showingEditActivityView = false
    
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
                            .contextMenu {
                                Button {
                                    activityToEdit = activity
                                    showingEditActivityView = true
                                } label: {
                                    Label("Изменить", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    print(activity.title)
                                    activityToDelete = activity
                                    confirmationShown = true
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                            .confirmationDialog(
                                "Вы уверены?",
                                isPresented: $confirmationShown,
                                titleVisibility: .visible
                            ) {
                                Button("Удалить", role: .destructive) {
                                    withAnimation {
                                        dataService.deleteActivity(id: activityToDelete!.id)
                                    }
                                }
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
        .fullScreenCover(item: $activityToEdit) { activity in
            EditActivityView(activity: activity)
        }
        .fullScreenCover(isPresented: $showAddActivityView) {
            AddActivityView()
        }
    }
}

#Preview {
    ActivityListView()
        .environment(DBService())
}
