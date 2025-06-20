import Foundation
import UIKit

class DebugAuthService {
    static let shared = DebugAuthService()
    private init() {}
    
    var jwtToken: String? = "debug"
    func signIn(presenting: UIViewController?, completion: @escaping (Bool) -> Void) {
        // Instantly succeed for debug
        completion(true)
    }
    func signOut() {
        jwtToken = nil
    }
} 
