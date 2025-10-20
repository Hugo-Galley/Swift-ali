import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            if viewModel.isLoggedIn {
                MainView()
                    .environmentObject(viewModel)
            } else {
                LoginView()
                    .environmentObject(viewModel)
            }
        }
        .animation(.easeInOut, value: viewModel.isLoggedIn)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
