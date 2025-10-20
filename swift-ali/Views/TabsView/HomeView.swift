import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText = ""
    
    let collumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView("Chargement des maillots...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    Text("Erreur")
                        .font(.title)
                        .bold()
                    Text(errorMessage)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    Button("Réessayer") {
                        Task {
                            await viewModel.loadProducts()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                LazyVGrid(columns: collumns, spacing: 16) {
                    ForEach(viewModel.products) { product in
                        NavigationLink(destination: ProductSelectionView(product: product)) {
                            CardView(
                                imageName: product.image,
                                title: product.name,
                                price: String(format: "%.2f €", product.price)
                            )
                        }
                        .foregroundColor(.black)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Boutique")
        .searchable(text: $searchText, prompt: "Rechercher un maillot...")
        .onChange(of: searchText) { oldValue, newValue in
            Task {
                await viewModel.searchProducts(query: newValue)
            }
        }
        .toolbar {
            NavigationLink(destination: CartView()) {
                Image(systemName: "cart.fill")
                    .foregroundColor(.psgRed)
            }
        }
        .task {
            await viewModel.loadProducts()
        }
    }
}
