import SwiftUI
import Drawer
import CoreLocation

struct EventDetailsView: View {
    @Binding var selectedEventID: Int?
    let onDismiss: () -> Void
    
    @State private var event: Event?
    @StateObject private var questService = QuestService.shared
    
    // mainly for rerenders
    @State var followedQuestId: Int? = nil

    init(selectedEventID: Binding<Int?>, onDismiss: @escaping () -> Void) {
        self._selectedEventID = selectedEventID
        self.onDismiss = onDismiss
    }
        
    // drawer stuff
    var collapsedHeight: CGFloat { 140 }
    var expandedHeight: CGFloat { UIScreen.main.bounds.height * 0.7 }

    var body: some View {
        
        if let eventID = selectedEventID {
            ZStack(alignment: .topLeading) {
                if let event = event {
                    EventMapView(event: event, selectedQuestId: followedQuestId)
                        .ignoresSafeArea()
                        .onAppear {
                            LocationService.shared.requestPermissionIfNeeded()
                        }
                } else {
                    // Show loading state when event is nil
                    Color.gray.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Loading event...")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Button {
                        onDismiss()
                    } label: {
                        Label("Lista wydarzeń", systemImage: "arrow.left")
                            .padding(10)
                            .padding(.horizontal, 2)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                    }
                }
                .padding()

                if let event = event, let weather = event.weather {
                    VStack {
                        HStack {
                            Spacer()
                            WeatherWidget(weather: weather)
                        }
                        Spacer()
                    }
                    .padding()
                } else {
                    // Debug: Show when weather is missing
                    VStack {
                        HStack {
                            Spacer()
                            Text("No weather data")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding()
                }
                
                Spacer()
                
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
                            
                            if let event = event {
                                if let quests = event.quests, !quests.isEmpty {
                                    QuestList(
                                        quests: quests,
                                        followedQuestId: followedQuestId,
                                        onFollow: { quest in
                                            if followedQuestId == quest.id {
                                                followedQuestId = nil
                                            } else {
                                                followedQuestId = quest.id
                                            }
                                            
                                            questService.setFollowedQuestId(followedQuestId, for: eventID)
                                        }
                                    )
                                } else {
                                    // Debug: Show when quests are missing
                                    VStack {
                                        Text("No quests available")
                                            .font(.headline)
                                        Text("Quests count: \(event.quests?.count ?? 0)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                }
                            } else {
                                ProgressView("Loading quests...")
                                    .padding()
                            }

                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.horizontal)
                    }
                }
                .edgesIgnoringSafeArea(.vertical)
            }
            .onAppear {
                onEventIdUpdate()
            }
            .onChange(of: selectedEventID) { newValue in
                // i know it's dep but without this it's gonna fail on next load
                // todo: find better workaround
                onEventIdUpdate()
            }
            
        }
        
    }
    
    private func onEventIdUpdate() {
        guard let eventID = selectedEventID else {
            self.event = nil
            return
        }
        
        if let selectedEventID = selectedEventID {
            followedQuestId = questService.getFollowedQuestId(for: selectedEventID)
        }
        
        // Clear current event to show loading state
        self.event = nil
        
        EventService.shared.fetchEventById(eventID, forceRefresh: true) { fetchedEvent in
            DispatchQueue.main.async {
                if let fetchedEvent = fetchedEvent {
                    self.event = fetchedEvent
                } else {
                    print("EventDetailsView: Failed to fetch event for ID: \(eventID)")
                }
            }
        }
    }
}
