import SwiftUI

struct ActivitySelector: View {
    @Environment(DBService.self) private var dataService
    @Binding var isTimerRunning: Bool
    
    var body: some View {
        ZStack {
            if !dataService.activities.isEmpty {
                if let currentActivity = dataService.currentActivity {
                    Text(currentActivity.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(
                            getTextColor(color: Color.fromHexString(currentActivity.color))
                        )
                        .font(.headline)
                        .animation(.none, value: dataService.currentActivity)
                }
                
                if dataService.activities.count > 1 && !isTimerRunning {
                    HStack {
                        Button {
                            withAnimation {
                                selectPrevious()
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                selectNext()
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .padding(.horizontal)
                        }
                    }
                    .foregroundStyle(getTextColor(color: Color.fromHexString(dataService.currentActivity?.color ?? "#FFFFFF")))
                }
            } else {
                switch dataService.activitiesLoadingState {
                case .loading:
                    ProgressView()
                        .padding()
                        .frame(maxWidth: .infinity)
                case .fetched:
                    Text("Создать активность")
                        .padding()
                        .foregroundStyle(.textPrimary)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                default:
                    EmptyView()
                }
            }
        }
        .animation(.default, value: dataService.activities)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    !dataService.activities.isEmpty && dataService.currentActivity != nil
                    ? Color.fromHexString(dataService.currentActivity!.color)
                    : Color.backgroundSecondary
                )
                .shadow(radius: 4)
        }
    }
    
    func selectPrevious() {
        if let currentIndex = dataService.activities.firstIndex(where: { $0.id == dataService.currentActivity?.id }) {
            if currentIndex > 0 {
                dataService.currentActivity = dataService.activities[currentIndex - 1]
            } else {
                dataService.currentActivity = dataService.activities.last
            }
        }
    }
    
    func selectNext() {
        if let currentIndex = dataService.activities.firstIndex(where: { $0.id == dataService.currentActivity?.id }) {
            if currentIndex < dataService.activities.count - 1 {
                dataService.currentActivity = dataService.activities[currentIndex + 1]
            } else {
                dataService.currentActivity = dataService.activities.first
            }
        }
    }
    
    func getTextColor(color: Color) -> Color {
        if color.isDark {
            return Color.textPrimary
        } else {
            return Color.accentText
        }
    }
}

#Preview {
    ActivitySelector(isTimerRunning: .constant(false))
        .environment(DBService())
}
