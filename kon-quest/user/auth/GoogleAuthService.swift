import Foundation
import GoogleSignIn
import UIKit

class GoogleAuthService {
    static let shared = GoogleAuthService()
    private init() {}
    
    var jwtToken: String?
    var user: GIDGoogleUser?

    func signIn(presenting: UIViewController, completion: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { signInResult, error in
            if let user = signInResult?.user {
                user.refreshTokensIfNeeded { refreshedUser, error in
                    guard let refreshedUser = refreshedUser, error == nil else {
                        DispatchQueue.main.async { completion(false) }
                        return
                    }
                    guard let idToken = refreshedUser.idToken?.tokenString else {
                        DispatchQueue.main.async { completion(false) }
                        return
                    }
                    
                    let url = URL(string: API_URL + "/auth/google")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    request.httpBody = try? JSONSerialization.data(withJSONObject: ["token": idToken])
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil,
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                              let jwt = json["token"] as? String else {
                            
                            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                print("GoogleAuthService - Failed with \(json)")
                            } else {
                                print("GoogleAuthService - Failed with \(response)")

                            }
                            DispatchQueue.main.async { completion(false) }
                            return
                        }
                        print("GoogleAuthService - Logined in\(jwt)")
                        DispatchQueue.main.async {
                            self.user = refreshedUser
                            self.jwtToken = jwt
                            completion(true)
                        }
                    }.resume()
                }
            } else {
                completion(false)
            }
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        user = nil
        jwtToken = nil
    }
} 
