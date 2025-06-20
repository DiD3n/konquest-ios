import Foundation
import SwiftUI
import UIKit

enum AuthProvider {
    case google, apple, debug
}

class UserService: ObservableObject {
    static let shared = UserService()
    @Published var jwtToken: String?
    @Published var provider: AuthProvider? = nil
    @Published var isSignedIn: Bool = false

    func signIn(with provider: AuthProvider, presenting: UIViewController, completion: @escaping (Bool) -> Void) {
        self.provider = provider
        switch provider {
        case .google:
            GoogleAuthService.shared.signIn(presenting: presenting) { success in
                DispatchQueue.main.async {
                    self.jwtToken = GoogleAuthService.shared.jwtToken
                    self.isSignedIn = success
                    completion(success)
                }
            }
        case .apple:
            AppleAuthService.shared.signIn(presenting: presenting) { success in
                DispatchQueue.main.async {
                    self.jwtToken = AppleAuthService.shared.jwtToken
                    self.isSignedIn = success
                    completion(success)
                }
            }
        case .debug:
            DebugAuthService.shared.signIn(presenting: presenting) { success in
                DispatchQueue.main.async {
                    self.jwtToken = DebugAuthService.shared.jwtToken
                    self.isSignedIn = success
                    completion(success)
                }
            }
        }
    }

    func signOut() {
        switch provider {
        case .google:
            GoogleAuthService.shared.signOut()
        case .apple:
            AppleAuthService.shared.signOut()
        case .debug:
            DebugAuthService.shared.signOut()
        case .none:
            break
        }
        jwtToken = nil
        isSignedIn = false
        provider = nil
    }
} 
