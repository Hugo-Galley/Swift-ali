import SwiftUI

struct ProductSelectionView: View {
    let product: Product
    
    @State private var selectedSize: String? = nil
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var cart: CartViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(product.name)
                            .font(.title2)
                            .bold()
                        
                        Image(product.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Équipe")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(product.team)
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(product.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Prix")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(String(format: "%.2f €", product.price))
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.psgBlue)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Stock")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(product.stock) disponibles")
                                    .font(.subheadline)
                                    .foregroundColor(product.stock > 10 ? .green : .orange)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Taille")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                ForEach(product.sizes, id: \.self) { size in
                                    Button(action: {
                                        selectedSize = size
                                    }) {
                                        Text(size)
                                            .fontWeight(.semibold)
                                            .frame(width: 60, height: 44)
                                            .background(selectedSize == size ? Color.psgBlue : Color.gray.opacity(0.2))
                                            .foregroundColor(selectedSize == size ? .white : .black)
                                            .cornerRadius(8)
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                Button(action: {
                    if let size = selectedSize {
                        // Créer un produit avec la taille sélectionnée pour le panier
                        // Note: Le CartViewModel devra être adapté pour gérer le nouveau modèle Product
                        cart.addToCart(product, size: size)
                        print("✅ Produit ajouté : \(product.name), taille : \(size)")
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Ajouter au panier")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(selectedSize == nil ? Color.gray : Color.psgBlue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .disabled(selectedSize == nil || product.stock == 0)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}
