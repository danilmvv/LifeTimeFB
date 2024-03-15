import SwiftUI

struct ActivitySelector: View {
    @Environment(DBService.self) private var dataService
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            if !dataService.activities.isEmpty {
                let currentActivity = dataService.activities[selectedIndex]
                
                Text(currentActivity.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(getTextColor(activity: currentActivity))
                    .font(.headline)
                    .animation(.none, value: selectedIndex)
                
                if dataService.activities.count > 1 {
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
                    .foregroundStyle(getTextColor(activity: currentActivity))
                }
            } else {
                Text("Создать активность")
                    .padding()
                    .foregroundStyle(.textPrimary)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    dataService.activities.isEmpty
                    ? Color.backgroundSecondary
                    : Color.fromHexString(dataService.activities[selectedIndex].color)
                )
        }
    }
    
    func selectPrevious() {
        if selectedIndex == 0 {
            selectedIndex = dataService.activities.count - 1
        } else {
            selectedIndex -= 1
        }
    }
    
    func selectNext() {
        if selectedIndex == dataService.activities.count - 1 {
            selectedIndex = 0
        } else {
            selectedIndex += 1
        }
    }
    
    func getTextColor(activity: Activity) -> Color {
        if Color.fromHexString(activity.color).isDark {
            return Color.textPrimary
        } else {
            return Color.accentText
        }
    }
}

#Preview {
    ActivitySelector(selectedIndex: .constant(0))
        .environment(DBService())
}
