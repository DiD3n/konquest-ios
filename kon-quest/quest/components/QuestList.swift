import SwiftUI

struct QuestList: View {
    let quests: [Quest]
    let followedQuestId: Int?
    let onFollow: ((Quest) -> Void)?
    
    init(quests: [Quest], followedQuestId: Int?, onFollow: ((Quest) -> Void)? = nil) {
        self.quests = quests
        self.followedQuestId = followedQuestId
        self.onFollow = onFollow
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let followedId = followedQuestId, let followed = quests.first(where: { $0.id == followedId }) {
                QuestCard(quest: followed, isActive: true) {
                    Button("Unfollow") {
                        onFollow?(followed)
                    }
                    .foregroundStyle(.white)
                }
            }
            
            let otherQuests = quests.filter { $0.id != followedQuestId }
            
            if !otherQuests.isEmpty {
                Text("Pozostałe zadania")
                    .font(.headline)
                ForEach(otherQuests) { quest in
                    QuestCard(quest: quest, isActive: false) {
                        Button("Follow") {
                            onFollow?(quest)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    QuestList(
        quests: [Quest.mock1, Quest.mock2],
        followedQuestId: 1,
        onFollow: { quest in print("Followed quest: \(quest.id)") }
    )
    .padding()
}
