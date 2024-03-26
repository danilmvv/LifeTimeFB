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
                    Spacer()
                    
                    CircularProgressView(
                        sessionDuration: $viewModel.sessionDuration,
                        showTime: $viewModel.isRunning
                    )
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        if dataService.currentActivity != nil {
                            withAnimation {
                                if viewModel.isRunning {
                                    viewModel.stopTimer()
                                    
                                    if viewModel.sessionDuration > 3 {
                                        viewModel.createSession(activity: dataService.currentActivity!)
                                        Task {
                                            do {
                                                try await dataService.saveSession(session: viewModel.currentSession!)
                                                viewModel.resetTimer()
                                                viewModel.showToast(message: "Сохранено!")
                                                try await dataService.getData()
                                                viewModel.resetDuration()
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
                        ProgressInfo(sessionDuration: $viewModel.sessionDuration)
                    } else {
                        // Placeholder
                        ProgressInfo(sessionDuration: $viewModel.sessionDuration)
                            .opacity(0)
                    }
                    
                    
                    Spacer()
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
//            .navigationTitle("Активность")
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
            .overlay(
                VStack {
                    if viewModel.showToast {
                        ToastView(message: viewModel.toastMessage)
                            .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        viewModel.showToast = false
                                    }
                                }
                            }
                    }
                    Spacer()
                }
            )
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
