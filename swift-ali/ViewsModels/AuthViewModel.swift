import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    func login() {
        if email.isEmpty || password.isEmpty {
            print("⚠️ Champs vides")
        } else {
            print("✅ Tentative connexion avec \(email)")
            // ici tu branches ton backend (Firebase, API, etc.)
        }
    }
    
    func register () {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            print("⚠️ Champs vides")
            return
        }
        
        if password != confirmPassword {
            print ("⚠️ Passwords ne correspondent pas")
            return
        }
        
        print("Nouvelle utilisateur : \(fullName), \(email)")
    }
}

