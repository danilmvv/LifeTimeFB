import SwiftUI

struct StatsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary
                    .ignoresSafeArea()
            }
            .navigationTitle("Статистика")
        }
    }
}

#Preview {
    StatsView()
}
