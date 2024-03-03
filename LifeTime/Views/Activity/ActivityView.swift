import SwiftUI

struct ActivityView: View {
    @State private var viewModel = ViewModel()
    @State private var selectedIndex: Int = 0
    let activities: [Activity] = [

    ]
    
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
                    .sensoryFeedback(
                        viewModel.isRunning
                        ? .impact(flexibility: .solid)  // Стоп
                        : .impact(flexibility: .soft),  // Старт
                        
                        trigger: viewModel.isRunning
                    )
                    
                    Text("\(viewModel.elapsedTime.toHours(decimals: 3)) ч.")
                        .padding(.top)
                    
                    Spacer()
                    ActivitySelector(selectedIndex: $selectedIndex, activities: activities)
                        .padding(.vertical)
                        .padding(.horizontal, 25)
                        .onTapGesture {
                            isSheetPresented.toggle()
                        }
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                if activities.isEmpty {
                    AddActivityView()
                } else {
                    ActivityListView(selectedIndex: $selectedIndex, activities: activities)
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}


#Preview {
    ActivityView()
}
