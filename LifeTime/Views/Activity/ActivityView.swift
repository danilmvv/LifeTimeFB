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
                        sessionDuration: $viewModel.sessionDuration,
                        progress: .constant(0.42),
                        showTime: $viewModel.isRunning
                    )
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        if dataService.currentActivity != nil {
                            withAnimation {
                                if viewModel.isRunning {
                                    viewModel.stopTimer()
                                    
                                    if viewModel.sessionDuration > 5 {
                                        viewModel.createSession(activity: dataService.currentActivity!)
                                        Task {
                                            do {
                                                try await dataService.saveSession(session: viewModel.currentSession!)
                                                viewModel.reset()
                                            } catch {
                                                viewModel.showSavingAlert = true
                                                print("Ошибка при сохранении")
                                            }
                                        }
                                    } else {
                                        viewModel.reset()
                                    }
                                } else {
                                    viewModel.startTimer()
                                }
                            }
                        } else {
                            viewModel.showActivityAlert = true
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
            .alert("Не удалось сохранить", isPresented: $viewModel.showSavingAlert) {
                Button("Повторить") {
                    Task {
                        do {
                            try await dataService.saveSession(session: viewModel.currentSession!)
                            viewModel.reset()
                        } catch {
                            viewModel.showSavingAlert = true
                            print("Ошибка при сохранении")
                        }
                    }
                }
                
                Button("Отмена", role: .cancel) {}
            }
            .alert("Добавьте активность!", isPresented: $viewModel.showActivityAlert) {
                Button("ОК", role: .cancel) {}
            }
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
