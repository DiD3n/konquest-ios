//
//  kon_questApp.swift
//  kon-quest
//
//  Created by Denis Wojtkowiak on 24/03/2025.
//

import SwiftUI
import GoogleSignIn

@main
struct kon_questApp: App {
    @State private var selectedEventID: Int? = UserDefaults.standard.object(forKey: "lastSelectedEventID") as? Int
    @StateObject private var userService = UserService.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !userService.isSignedIn {
                    LoginView()
                } else {
                    ZStack {
                        if selectedEventID != nil {
                            Group {
                                EventDetailsView(selectedEventID: $selectedEventID, onDismiss: {
                                    selectedEventID = nil
                                    UserDefaults.standard.removeObject(forKey: "lastSelectedEventID")
                                })
                            
                            }.transition(.move(edge: .trailing))
                        } else {
                            EventListView(selectedEventID: Binding(
                                get: { self.selectedEventID },
                                set: { newValue in
                                    self.selectedEventID = newValue
                                    if let id = newValue {
                                        UserDefaults.standard.set(id, forKey: "lastSelectedEventID")
                                    } else {
                                        UserDefaults.standard.removeObject(forKey: "lastSelectedEventID")
                                    }
                                }
                            ))
                            .transition(.move(edge: .leading))
                        }
                    }
                    .animation(.easeInOut.speed(1.5), value: selectedEventID)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

