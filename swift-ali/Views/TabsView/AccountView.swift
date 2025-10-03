import SwiftUI
import PhotosUI

struct AccountView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isDarkMode = false
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var pickerItem: PhotosPickerItem? = nil
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        VStack {
            if let img = selectedImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding()
            } else if let user = viewModel.currentUser, let path = user.profileImage,
                      let uiImg = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImg)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .padding()
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            PhotosPicker(selection: $pickerItem, matching: .images) {
                Text("Changer la photo")
                    .foregroundColor(.blue)
            }
            .onChange(of: pickerItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                        saveProfileImage(uiImage)
                    }
                }
            }
            
            if let user = viewModel.currentUser {
                Form {
                    TextField("Nom complet", text: $fullName)
                    TextField("Email", text: $email)
                    SecureField("Mot de passe", text: $password)
                    
                    Toggle(isOn: $isDarkMode) {
                        Text("Mode sombre")
                    }
                }
                .onAppear {
                    fullName = user.fullName
                    email = user.email
                    password = user.password
                }
                
                Button(action: {
                    viewModel.updateProfile(
                        fullName: fullName,
                        email: email,
                        password: password,
                        profileImage: getProfileImagePath()
                    )
                }) {
                    Text(" Enregistrer")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.psgBlue)
                        .cornerRadius(10)
                }
                
                .padding()
                
                Button(action: {
                                    showLogoutAlert = true
                                }) {
                                    Text(" Déconnexion")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.psgRed)
                                        .cornerRadius(10)
                                }
                                .padding()
                                .alert("Voulez-vous vous déconnecter ?", isPresented: $showLogoutAlert) {
                                    Button("Annuler", role: .cancel) {}
                                    Button("Déconnexion", role: .destructive) {
                                        viewModel.logout()
                                    }
                                } message: {
                                    Text("Vous serez redirigé vers la page de connexion.")
                                }
                            }
                        }
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    
    private func saveProfileImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent("profile.jpg")
            try? data.write(to: filename)
        }
    }
    
    private func getProfileImagePath() -> String? {
        let filename = getDocumentsDirectory().appendingPathComponent("profile.jpg")
        return filename.path
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
}
