import SwiftUI

struct EventListView: View {
    @Binding var selectedEventID: Int?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .clear]),
                startPoint: .top,
                endPoint: .center
            )
            .opacity(0.75)
            .ignoresSafeArea(edges: .top)
            
            VStack {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Hejka! 👋")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Gdzie cie tym razem wywiało? 💨")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    HStack {
                        UserIcon()
                    }
                }
                .padding(.horizontal)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .clear.opacity(0)]),
                        startPoint: .top,
                        endPoint: .center
                    )
                    .opacity(0.5)
                    .ignoresSafeArea(edges: .top)
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        

                        EventList(selectedEventID: $selectedEventID)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    EventListView(selectedEventID: .constant(nil))
}
