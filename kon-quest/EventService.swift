import Foundation

class EventService {
    static let shared = EventService()
    private init() {}
    
    // MARK: - Caches
    private var eventsCache: [Int: Event] = [:]
    private var eventsListCache: [Event]? = nil
    private var questsCache: [Int: Quest] = [:]
    private var questsListCache: [Quest]? = nil
    
    // MARK: - Event APIs
    func fetchEventsList(forceRefresh: Bool = false, completion: @escaping ([Event]?) -> Void) {
        print("[EventService] fetchEventsList(forceRefresh: \(forceRefresh))")
        if !forceRefresh, let cached = eventsListCache {
            print("[EventService] fetchEventsList: cache hit")
            completion(cached)
            return
        }
        print("[EventService] fetchEventsList: fetching from API")
        guard let url = URL(string: "\(API_URL)/events") else {
            print("[EventService] fetchEventsList: invalid URL")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("[EventService] fetchEventsList: network error \(String(describing: error))")
                completion(nil)
                return
            }
            
            do {
                let events = try JSONDecoder().decode([Event].self, from: data)
                print("[EventService] fetchEventsList: decoded \(events.count) events")
                self?.eventsListCache = events
                DispatchQueue.main.async { completion(events) }
            } catch {
                print("[EventService] fetchEventsList: decode error \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    func fetchEventById(_ id: Int, forceRefresh: Bool = false, completion: @escaping (Event?) -> Void) {
        print("[EventService] fetchEventById(id: \(id), forceRefresh: \(forceRefresh))")
        if !forceRefresh, let cached = eventsCache[id] {
            print("[EventService] fetchEventById: cache hit for id \(id)")
            completion(cached)
            return
        }
        print("[EventService] fetchEventById: fetching from API for id \(id)")
        guard let url = URL(string: "\(API_URL)/events/\(id)") else {
            print("[EventService] fetchEventById: invalid URL for id \(id)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("[EventService] fetchEventById: network error \(String(describing: error))")
                completion(nil)
                return
            }
            
            do {
                let event = try JSONDecoder().decode(Event.self, from: data)
                print("[EventService] fetchEventById: decoded event for id \(id)")
                self?.eventsCache[id] = event
                DispatchQueue.main.async { completion(event) }
            } catch {
                print("[EventService] fetchEventById: decode error \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    // MARK: - Quest APIs (Stub)
    func fetchQuestsList(forceRefresh: Bool = false, completion: @escaping ([Quest]?) -> Void) {
        print("[EventService] fetchQuestsList(forceRefresh: \(forceRefresh))")
        if let cached = questsListCache, !forceRefresh {
            print("[EventService] fetchQuestsList: cache hit")
            completion(cached)
            return
        }
        print("[EventService] fetchQuestsList: returning stubbed quests")
        // Simulate async stub
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let quests = [Quest.mock1, Quest.mock2]
            self.questsListCache = quests
            for quest in quests { self.questsCache[quest.id] = quest }
            completion(quests)
        }
    }
    
    func fetchQuestById(_ id: Int, forceRefresh: Bool = false, completion: @escaping (Quest?) -> Void) {
        print("[EventService] fetchQuestById(id: \(id), forceRefresh: \(forceRefresh))")
        if let cached = questsCache[id], !forceRefresh {
            print("[EventService] fetchQuestById: cache hit for id \(id)")
            completion(cached)
            return
        }
        print("[EventService] [stub] fetchQuestById: returning stubbed quest for id \(id)")
        // Simulate async stub
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let quest = [Quest.mock1, Quest.mock2].first { $0.id == id }
            self.questsCache[id] = quest
            completion(quest)
        }
    }
    
    // MARK: - Actions
    func clearCache() {
        print("[EventService] clearCache()")
        eventsCache.removeAll()
        eventsListCache = nil
        questsCache.removeAll()
        questsListCache = nil
    }
    
    func refreshAll(completion: (() -> Void)? = nil) {
        print("[EventService] refreshAll()")
        clearCache()
        let group = DispatchGroup()
        group.enter()
        fetchEventsList(forceRefresh: true) { _ in group.leave() }
        group.enter()
        fetchQuestsList(forceRefresh: true) { _ in group.leave() }
        group.notify(queue: .main) { 
            print("[EventService] refreshAll: done")
            completion?() 
        }
    }
} 
