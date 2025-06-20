import Foundation
import UIKit

class AppleAuthService {
    static let shared = AppleAuthService()
    private init() {}
    
    var jwtToken: String?
    func signIn(presenting: UIViewController, completion: @escaping (Bool) -> Void) {
        // todo: Implement Apple sign-in here
        completion(false)
    }
    func signOut() {
        jwtToken = nil
    }
} 
