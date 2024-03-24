import SwiftUI

struct HistoryView: View {
    @Environment(DBService.self) private var dataService
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                List(dataService.sessions) { session in
                    HistoryItem(session: session)
                        .listRowBackground(Color.backgroundSecondary)
                }
                .transition(.slide)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("История")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isSheetPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .tint(.accent)
                    }
                }
            }
            .sheet(isPresented: $isSheetPresented, onDismiss: {
                Task {
                    do {
                        try await dataService.getData()
                        print("update")
                    } catch {
                        print(error)
                    }
                }
            }) {
                AddSessionView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    HistoryView()
        .environment(DBService())
}
