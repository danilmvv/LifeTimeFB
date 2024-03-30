import SwiftUI

struct EditActivityView: View {
    @Environment(DBService.self) private var dataService
    
    @State var activity: Activity
    @State private var selectedDays: [String] = []
    
    @Environment(\.dismiss) var dismiss
    
    var goal: Double {
        return activity.goal / 3600
    }
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Изменить активность")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    
                    CustomTextField(placeholder: "Название", text: $activity.title)

                    VStack(spacing: 32) {
                        AppButton(title: "Сохранить активность") {
                            Task {
                                do {
                                    try await dataService.updateActivity(activity: activity)
                                    dataService.currentActivity = activity
                                    dismiss()
                                } catch {
                                    print(error)
                                    dismiss()
                                }
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
        }
    }
}

#Preview {
    EditActivityView(activity: Activity.default)
        .environment(DBService())
}
