import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    func login() {
        if email.isEmpty || password.isEmpty {
            print("⚠️ Champs vides")
        } else {
            print("✅ Tentative connexion avec \(email)")
            // ici tu branches ton backend (Firebase, API, etc.)
        }
    }
}

