import SwiftUI

struct QuestCard<Actions: View>: View {
    let quest: Quest
    let isActive: Bool
    let actions: (() -> Actions)?

    var body: some View {
        Group {
            HStack {
                questTypeIcon(quest: quest)
                    .padding(.horizontal, 8)
                    .foregroundColor(isActive ? .white : .primary)

                VStack(alignment: .leading) {
                    Text(quest.name)
                        .font(.headline)
                        .foregroundColor(isActive ? .white : .primary)
                    
                    Text(quest.description)
                        .font(.subheadline)
                        .foregroundColor(isActive ? .white.opacity(0.8) : .secondary)
                }
                Spacer()
                if let actions = actions {
                    actions()
                }
            }
        }
        .padding(6)
        .padding(.horizontal, 12)
        .background( isActive ? .blue.opacity(0.5) : .red.opacity(0))
        .background(Material.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isActive ? Color.accentColor : Color.clear, lineWidth: isActive ? 4 : 0)
        )
        .shadow(radius: 8)
        .cornerRadius(16)
    }
    
    @ViewBuilder
    func questTypeIcon(quest: Quest) -> some View {
        switch quest.type {
        case .walk:
            Image(systemName: "figure.walk")
        case .walk_to:
            Image(systemName: "mappin.and.ellipse")
        case .explore:
            Image(systemName: "map")
        default:
            Image(systemName: "questionmark.circle")
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        QuestCard(quest: .mock1, isActive: true) {
            Button("TEST") {}
        }
        QuestCard(quest: .mock2, isActive: false) {
            Button("TEST") {}
        }
    }
    .padding()
}
