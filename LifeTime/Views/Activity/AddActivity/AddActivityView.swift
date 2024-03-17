import SwiftUI

struct AddActivityView: View {
    @Environment(DBService.self) private var dataService
    
    @State private var viewModel = ViewModel()
    @State private var selectedDays: [String] = []
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Новая активность")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                CustomTextField(placeholder: "Название", text: $viewModel.title)
                
                HStack(spacing: 16) {
                    CustomNumberField(placeholder: "Цель", number: $viewModel.goal, unit: "ч.")
                        .frame(maxWidth: .infinity)
                    
                    Menu {
                        Picker("Цель", selection: $viewModel.goalType) {
                            ForEach(GoalType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.goalType.rawValue)
                                .fontWeight(.bold)
                            
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 16))
                        }
                        .foregroundStyle(.appWhite)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                        }
                    }
                }
                
                ColorPicker("Цвет", selection: $viewModel.color)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                    }
                
                Toggle("Уведомления", isOn: $viewModel.notificationsEnabled)
                    .tint(.accentColor)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                    }
                
                VStack(spacing: 16) {
                    DatePicker("Напомнить в", selection: $viewModel.notificationTime, displayedComponents: [.hourAndMinute])
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxHeight: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                        }
                        .allowsHitTesting(viewModel.notificationsEnabled)
                    
                    DaysPicker(selectedDays: $viewModel.notificationDays)
                        .allowsHitTesting(viewModel.notificationsEnabled)
                }
                .opacity(viewModel.notificationsEnabled ? 1 : 0.5)
                
                VStack(spacing: 32) {
                    AppButton(title: "Добавить активность") {
                        if viewModel.canSave {
                            let newActivity = viewModel.createActivity()
                            
                            Task {
                                do {
                                    try await dataService.addActivity(activity: newActivity)
                                    dataService.currentActivity = newActivity
                                    dismiss()
                                } catch {
                                    print(error)
                                    dismiss()
                                }
                            }
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Отменить")
                            .fontWeight(.bold)
                            .foregroundStyle(.textSecondary)
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Ошибка!"), message: Text("Пожалуйста, заполните все поля"))
        }
    }
}

#Preview {
    AddActivityView()
        .environment(DBService())
}
