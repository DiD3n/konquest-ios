import SwiftUI

struct EventList: View {
    @Binding var selectedEventID: Int?
    @State private var events: [Event] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(events, id: \.id) { event in
                    Button {
                        selectedEventID = event.id
                    } label: {
                        EventCard(event: event)
                    }
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            fetchEvents()
        }
    }
    
    func fetchEvents() {
        guard events.count == 0 else { return }
        EventService.shared.fetchEventsList { events in
             if let events = events {
                 self.events = events
             }
        }
    }
}


#Preview {
}
