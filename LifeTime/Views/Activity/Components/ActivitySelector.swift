import SwiftUI

struct ActivitySelector: View {
    @Environment(DBService.self) private var dataService
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            if !dataService.activities.isEmpty {
                
                Text(dataService.activities[selectedIndex].title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
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
                }
            } else {
                Text("Создать активность")
                    .padding()
                    .foregroundStyle(.primary)
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
}

#Preview {
    ActivitySelector(selectedIndex: .constant(0))
        .environment(DBService())
}
