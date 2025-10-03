import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoggedIn {
                MainView()
            } else {
                LoginView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
