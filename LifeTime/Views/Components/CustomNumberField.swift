import SwiftUI

struct CustomNumberField: View {
    var placeholder: String
    @Binding var number: Double
    var unit: String?
    
    var body: some View {
        HStack {
            TextField(placeholder, value: $number, formatter: numberFormatter)
                .keyboardType(.decimalPad)
            
            if let unit = unit {
                Text(unit)
            }
        }
        .padding()
        .frame(maxHeight: 50)
        .foregroundStyle(.primary)
        .fontWeight(.bold)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        }
    }
    
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        formatter.maximumFractionDigits = 1
        
        return formatter
    }
}

#Preview {
    CustomNumberField(placeholder: "Цель", number: .constant(0), unit: "ч.")
}
