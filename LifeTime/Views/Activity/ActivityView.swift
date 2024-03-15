import SwiftUI

struct ActivityView: View {
    @Environment(DBService.self) private var dataService
    @State private var viewModel = ViewModel()
    @State private var selectedIndex: Int = 0
    
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
                    ActivitySelector(selectedIndex: $selectedIndex)
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
            .sheet(isPresented: $isSheetPresented, onDismiss: {
                Task {
                    do {
                        try await dataService.getData()
                    } catch {
                        print(error)
                    }
                }
            }) {
                if dataService.activities.isEmpty {
                    AddActivityView()
                        .presentationDragIndicator(.visible)
                } else {
                    ActivityListView(selectedIndex: $selectedIndex)
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}


#Preview {
    ActivityView()
        .environment(DBService())
}
