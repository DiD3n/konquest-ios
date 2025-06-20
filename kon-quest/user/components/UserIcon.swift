import SwiftUI


struct UserIcon: View {
    @State private var showMenu = false
    
    var body: some View {
        Button {
            showMenu = true
        } label: {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .confirmationDialog("Moje konto", isPresented: $showMenu, titleVisibility: .visible) {
                    Button(role: .destructive) {
                        UserService.shared.signOut()
                    } label: {
                        Label("Wyloguj", systemImage: "arrow.backward.circle")
                    }
                }
                .contextMenu {
                    Button(role: .destructive) {
                        UserService.shared.signOut()
                    } label: {
                        Label("Wyloguj", systemImage: "arrow.backward.circle")
                    }
                }
        }
    }
}

