import SwiftUI

struct HistoryView: View {
    @Environment(DBService.self) private var dataService
    @State private var isSheetPresented: Bool = false
    
    private var activityDictionary: [String: Activity] {
        Dictionary(uniqueKeysWithValues: dataService.activities.map { ($0.id, $0) })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
                
                List{
                    ForEach(dataService.sessions) { session in
                        HistoryItem(title: getActivityTitle(session: session), session: session)
                            .swipeActions {
                                Button {
                                    dataService.deleteSession(id: session.id)
                                } label: {
                                    Text("Удалить")
                                }
                                .tint(Color.appRed)
                            }
                    }
                    .listRowBackground(Color.backgroundSecondary)
                }
                .scrollContentBackground(.hidden)
                .animation(.default, value: dataService.sessions)
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
    
    private func getActivityTitle(session: Session) -> String {
        activityDictionary[session.activityID]?.title ?? "Неизвестное"
    }
}

#Preview {
    HistoryView()
        .environment(DBService())
}
