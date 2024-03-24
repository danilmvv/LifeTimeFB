import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.backgroundPrimary
            
            VStack{
                Image(uiImage: UIImage(imageLiteralResourceName: "AppIcon"))
                    .resizable()
                    .scaledToFit()
                
                Text("LifeTime")
                    .font(.headline)
                    .foregroundStyle(.textPrimary)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
