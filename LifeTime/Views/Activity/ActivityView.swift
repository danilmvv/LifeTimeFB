import SwiftUI

struct ActivityView: View {
    @Environment(DBService.self) private var dataService
    @State private var viewModel = ViewModel()
    
    @State private var isSheetPresented = false
    
    var body: some View {
        @Bindable var dataService = dataService
        
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    CircularProgressView(
                        currentActivity: $dataService.currentActivity,
                        elapsedTime: $viewModel.elapsedTime,
                        progress: .constant(0.42),
                        showTime: $viewModel.isRunning
                    )
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        if dataService.currentActivity != nil {
                            withAnimation {
                                if viewModel.isRunning {
                                    viewModel.stopTimer()
    //                                viewModel.createSession(activity: dataService.currentActivity!)
                                } else {
                                    viewModel.startTimer()
                                }
                            }
                        } else {
                            print("Нет активности!")
                        }
                    }
                    .sensoryFeedback(.impact(flexibility: .solid), trigger: viewModel.isRunning)
                    
                    Spacer()
                    
                    if !dataService.activities.isEmpty {
                        ProgressInfo()
                    } else {
                        // Placeholder
                        ProgressInfo()
                            .opacity(0)
                    }
                    
                    
                    Spacer()
                    ActivitySelector(isTimerRunning: $viewModel.isRunning)
                        .padding(.top)
                        .padding(.bottom, 25)
                        .padding(.horizontal, 25)
                        .onTapGesture {
                            if !viewModel.isRunning {
                                isSheetPresented.toggle()
                            } else {
                                print("Нельзя менять активность при запущенном таймере")
                            }
                        }
                        .sensoryFeedback(.impact(flexibility: .soft), trigger: dataService.currentActivity)
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
                    ActivityListView()
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
