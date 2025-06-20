import SwiftUI
import UIKit

struct LoginView: View {
    @ObservedObject var userService = UserService.shared
    @State private var isSigningIn = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            VStack {
                Text("KonQuest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Przewodnik po konwentach")
            }
            Spacer()
            VStack(spacing: 12) {
                Text("Zaloguj sie sie aby zachować progress")
                    .font(.footnote)
                Button {
                    isSigningIn = true
                    if let rootVC = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?.windows.first?.rootViewController {
                        userService.signIn(with: .apple, presenting: rootVC) { success in
                            isSigningIn = false
                            if !success {
                                errorMessage = "Apple sign-in failed."
                            }
                        }
                    } else {
                        isSigningIn = false
                        errorMessage = "Could not get root view controller."
                    }
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Konto Apple")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                Button  {
                    isSigningIn = true
                    if let rootVC = UIApplication.shared.connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?.windows.first?.rootViewController {
                        userService.signIn(with: .google, presenting: rootVC) { success in
                            isSigningIn = false
                            if !success {
                                errorMessage = "Google sign-in failed."
                            }
                        }
                    } else {
                        isSigningIn = false
                        errorMessage = "Could not get root view controller."
                    }
                } label: {
                    HStack {
                        Image(systemName: "globe")
                        Text("Konto Google")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 219/255, green: 68/255, blue: 55/255))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
//                Button {
//                    isSigningIn = true
//                    if let rootVC = UIApplication.shared.connectedScenes
//                        .compactMap({ $0 as? UIWindowScene })
//                        .first?.windows.first?.rootViewController {
//                        userService.signIn(with: .debug, presenting: rootVC) { success in
//                            isSigningIn = false
//                            if !success {
//                                errorMessage = "Debug sign-in failed."
//                            }
//                        }
//                    } else {
//                        isSigningIn = false
//                        errorMessage = "Could not get root view controller."
//                    }
//                } label: {
//                    HStack {
//                        Image(systemName: "person")
//                        Text("Konto Debug")
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.gray)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//                }
            }
            
            
            if isSigningIn {
                ProgressView()
            }
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
} 
