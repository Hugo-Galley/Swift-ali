import Foundation
import Combine


class AuthViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    
    @Published var isLoggedIn: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let db = DatabaseManager.shared
    
    
    func login() {
        if db.validateUser(email: email,  password: password) {
            print("Connexion réussie")
            isLoggedIn = true
            alertMessage = "Connexion Réussie !"
        } else {
            alertMessage = "Email ou mot de passe invalide ! "
        }
        showAlert = true
    }
    
    func register() {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            print ("Champs vides")
            alertMessage = "veuillez remplir tous les champs"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            print ("Les Mots de passe différents")
            alertMessage = "Les mots de passe ne correspondent pas"
            showAlert = true
            return
        }
        
        db.insertUser(fullName: fullName, email: email, password: password)
        alertMessage = "compte créé avec succès !"
        
        fullName = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
    
}

