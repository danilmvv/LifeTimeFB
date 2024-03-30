import SwiftUI

struct AddSessionView: View {
    @Environment(DBService.self) private var dataService
    @State private var viewModel = ViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State private var isSheetPresented = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Добавить Сессию")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                ActivitySelector(isTimerRunning: .constant(false))
                    .onTapGesture {
                        isSheetPresented.toggle()
                    }
                
                HStack(spacing: 16) {
                    VStack {
                        Text("Начало")
                            .font(.headline)
                        DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    VStack {
                        Text("Конец")
                            .font(.headline)
                        DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: [.hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("День")
                            .font(.headline)
                        DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                        .labelsHidden()
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                }
                
                AppButton(title: "Добавить Сессию") {
                    guard let currentActivity = dataService.currentActivity else {
                        // TODO: alert
                        print("Ошибка при добавлении Сессии")
                        return
                    }
                    
                    let session = viewModel.createSession(activity: currentActivity)
                    
                    Task {
                        do {
                            try await dataService.saveSession(session: session)
                            dismiss()
                        } catch {
                            // TODO: alert
                            print("Ошибка при сохранении")
                        }
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $isSheetPresented) {
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

#Preview {
    AddSessionView()
        .environment(DBService())
}
