import SwiftUI
import PhotosUI

struct AccountView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var cart: CartViewModel
    @State private var isDarkMode = false
    
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
                VStack(spacing: 20) {
                    // Affichage nom et email en lecture seule
                    Text(user.fullName)
                        .font(.title2)
                        .bold()
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Toggle dark mode
                    Toggle(isOn: $isDarkMode) {
                        Text("Mode sombre")
                    }
                    .padding(.horizontal)
                    
                    // Bouton Mes commandes
                    NavigationLink(destination: OrdersView()
                                    .environmentObject(viewModel)
                                    .environmentObject(cart)) {
                        Text("Mes commandes")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Bouton Déconnexion
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Text("Déconnexion")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.psgRed)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .alert("Voulez-vous vous déconnecter ?", isPresented: $showLogoutAlert) {
                        Button("Annuler", role: .cancel) {}
                        Button("Déconnexion", role: .destructive) {
                            viewModel.logout()
                        }
                    } message: {
                        Text("Vous serez redirigé vers la page de connexion.")
                    }
                }
                .padding()
            }
            
            Spacer()
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
