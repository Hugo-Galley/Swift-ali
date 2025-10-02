import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.liquidGlass, .white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack (spacing : 25 ) {
                Image(systemName: "tshirt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame( width: 100, height: 100)
                    .foregroundColor(.psgRed)
                    .padding(.bottom, 30)
                
                TextField("Nom Complet", text: $viewModel.fullName)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .autocapitalization(.none)
                
                SecureField("Mot de Passe", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                
                SecureField("Confirmer le mot de passe", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                
                Button(action: {
                    viewModel.register()
                }) {
                    Text("S'inscrire")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.psgRed, .psgBlue],
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                        .cornerRadius(12)
                }
                
                HStack {
                    Text("Déjà un compte ?")
                    NavigationLink(destination: LoginView()) {
                        Text("Se connecter")
                            .foregroundColor(.psgBlue)
                            .bold()
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
        }
        .navigationTitle("Inscription")
        .navigationBarTitleDisplayMode(.inline)
    }
}
