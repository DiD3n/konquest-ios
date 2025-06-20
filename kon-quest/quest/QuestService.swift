import Foundation

// Progress for a single quest
struct QuestProgress: Codable {
    var questId: Int
    var visitedPoints: Set<String> = []
    var stepsTaken: Int = 0
}

// State for all quests within a single event, including which one is followed
struct EventQuestsState: Codable {
    var eventId: Int
    var followedQuestId: Int?
    var questProgress: [Int: QuestProgress] = [:]
}

class QuestService: ObservableObject {
    static let shared = QuestService()
    
    @Published var eventsState: [Int: EventQuestsState] = [:]
    
    private let userDefaultsKey = "eventsQuestsState"
    
    private init() {
        loadState()
    }
    
    // MARK: - State Management
    
    private func getEventState(for eventId: Int) -> EventQuestsState {
        if let state = eventsState[eventId] {
            return state
        } else {
            let newState = EventQuestsState(eventId: eventId)
            eventsState[eventId] = newState
            return newState
        }
    }
    
    // MARK: - Followed Quest Management
    
    func getFollowedQuestId(for eventId: Int) -> Int? {
        return getEventState(for: eventId).followedQuestId
    }
    
    func setFollowedQuestId(_ questId: Int?, for eventId: Int) {
        var state = getEventState(for: eventId)
        state.followedQuestId = questId
        eventsState[eventId] = state
        saveState()
    }
    
    // MARK: - Quest Progress Management
    
    func getProgress(for questId: Int, inEvent eventId: Int) -> QuestProgress {
        let eventState = getEventState(for: eventId)
        if let progress = eventState.questProgress[questId] {
            return progress
        } else {
            let newProgress = QuestProgress(questId: questId)
            var mutableEventState = eventState
            mutableEventState.questProgress[questId] = newProgress
            eventsState[eventId] = mutableEventState
            return newProgress
        }
    }
    
    func visitPoint(for questId: Int, inEvent eventId: Int, pointId: String) {
        var progress = getProgress(for: questId, inEvent: eventId)
        progress.visitedPoints.insert(pointId)
        
        var eventState = getEventState(for: eventId)
        eventState.questProgress[questId] = progress
        eventsState[eventId] = eventState
        
        saveState()
    }
    
    func updateSteps(for questId: Int, inEvent eventId: Int, steps: Int) {
        var progress = getProgress(for: questId, inEvent: eventId)
        progress.stepsTaken = steps
        
        var eventState = getEventState(for: eventId)
        eventState.questProgress[questId] = progress
        eventsState[eventId] = eventState
        
        saveState()
    }
    
    // MARK: - Persistence
    
    private func saveState() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(eventsState) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadState() {
        guard let savedStateData = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        
        let decoder = JSONDecoder()
        if let decodedState = try? decoder.decode([Int: EventQuestsState].self, from: savedStateData) {
            eventsState = decodedState
        }
    }
} 
