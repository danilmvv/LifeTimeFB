import SwiftUI

struct ActivityListView: View {
    @Environment(DBService.self) private var dataService
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedIndex: Int
    @State private var showAddActivityView: Bool = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Выберите активность")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    
                    ForEach(0..<dataService.activities.count, id: \.self) { index in
                        ActivityInfoCard(activity: dataService.activities[index])
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
}

#Preview {
    ActivityListView(selectedIndex: .constant(0))
        .environment(DBService())
}
