import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel =  AuthViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.liquidGlass, .white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack ( spacing: 25) {
                Image(systemName: "sportscourt.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.psgBlue)
                    .padding(.bottom, 30)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .autocapitalization(.none)
                
                SecureField("Mot de Passe", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                
                Button(action: {
                    viewModel.login()
                }) {
                    Text("Se connecter")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [.psgBlue, .psgRed],
                                                   startPoint: .leading,
                                                   endPoint: .trailing))
                        .cornerRadius(12)
                }
                
                HStack {
                    Text("Pas de compte ?")
                    Button("S'inscrire") {
                    }
                    .foregroundColor(.psgRed)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
        }
    }
}
