import Foundation
import SwiftUI

extension Color {
    static func random() -> Color {
        let minHue: Double = 0
        let maxHue: Double = 1
        let minVal: Double = 0.8
        let maxVal: Double = 1
        
        let hue = Double.random(in: minHue...maxHue)
        let saturation = Double.random(in: minVal...maxVal)
        let brightness = Double.random(in: minVal...maxVal)
        
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}

