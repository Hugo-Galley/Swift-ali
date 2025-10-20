import Foundation
import Combine


class AuthViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var currentUser: User? = nil
    
    private lazy var db = DatabaseManager.shared
    
    
    func login() {
        let email = self.email
        let password = self.password
        DispatchQueue.main.async {
            self.isLoading = true
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let valid = self.db.validateUser(email: email, password: password)
            if valid {
                let user = self.db.getUserByEmail(email: email)
                DispatchQueue.main.async {
                    print("Connexion réussie")
                    self.isLoggedIn = true
                    self.alertMessage = "Connexion Réussie !"
                    self.currentUser = user
                    self.showAlert = true
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Email ou mot de passe invalide ! "
                    self.showAlert = true
                    self.isLoading = false
                }
            }
        }
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
        
        let fName = fullName
        let mail = email
        let pwd = password
        let pImage: String? = nil
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.db.insertUser(fullName: fName, email: mail, password: pwd, profileImage: pImage)
            DispatchQueue.main.async {
                self.alertMessage = "compte créé avec succès !"
                self.showAlert = true

                self.fullName = ""
                self.email = ""
                self.password = ""
                self.confirmPassword = ""
            }
        }
    }
    
    func updateProfile(fullName: String, email: String, password: String, profileImage: String?) {
        guard var user = currentUser else { return }
        user.fullName = fullName
        user.email = email
        user.password = password
        user.profileImage = profileImage
        // Update en background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.db.updateUser(user: user)
            DispatchQueue.main.async {
                self.currentUser = user
            }
        }
    }
    
    func logout() {
        currentUser = nil
        isLoggedIn = false
        email = ""
        password = ""
        fullName = ""
        confirmPassword = ""
        print("Deconnexion reussie")
    }
}

