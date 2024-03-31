import Foundation
import SwiftUI

struct ChartItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let totalTime: TimeInterval
    let color: Color
}
