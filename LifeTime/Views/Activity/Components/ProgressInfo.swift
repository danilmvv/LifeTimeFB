import SwiftUI

struct ProgressInfo: View {
    var body: some View {
        VStack {
            Text("17/50 ч.")
                .font(.headline)
                .fontWeight(.bold)
            Text("на этой неделе")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.textSecondary)
    }
}

#Preview {
    ProgressInfo()
}
