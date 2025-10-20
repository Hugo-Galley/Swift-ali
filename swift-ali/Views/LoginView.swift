import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    
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
                    .disabled(viewModel.isLoading)
                
                SecureField("Mot de Passe", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                    .disabled(viewModel.isLoading)
                
                Button(action: {
                    viewModel.login()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(12)
                    } else {
                        Text("Se connecter")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [.psgBlue, .psgRed],
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .cornerRadius(12)
                    }
                }
                .disabled(viewModel.isLoading)
                
                HStack {
                    Text("Pas de compte ?")
                    NavigationLink(destination: RegisterView().environmentObject(viewModel)) {
                        Text("S'inscrire")
                            .foregroundColor(.psgRed)
                            .bold()
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
        }
        .navigationTitle("Connexion")
        .navigationBarTitleDisplayMode(.inline)
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        }
        
    }
}
