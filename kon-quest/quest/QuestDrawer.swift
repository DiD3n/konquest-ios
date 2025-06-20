import SwiftUI
import Drawer

#Preview {
    Drawer(heights: .constant([100, 650])) {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .padding(.horizontal)
                .foregroundColor(.white.opacity(0)) // workaround for black square
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal)
            
            VStack(alignment: .center) {
                Spacer().frame(height: 4.0)
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Quests")
                    .font(.title2)
                    .foregroundStyle(.foreground)
                Spacer()
            }
        }
    }
    .background(.red)
    .edgesIgnoringSafeArea(.vertical)
}
