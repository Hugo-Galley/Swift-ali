import SwiftUI

struct ProductSelectionView: View {
    var imageName: String
    var title: String
    var price: String
    var sizes: [String]

    @State private var selectedSize: String? = nil
    @Environment(\.presentationMode) var presentationMode

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
                
                // TITRE DU PRODUIT
                Text(title)
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                // IMAGE DU PRODUIT
                Image(imageName)
                    .resizable()
                    .frame(height: 300)
                    .cornerRadius(0)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                // PRIX
                Text("Prix : \(price)")
                    .font(.body)
                    .fontWeight(.regular)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                // SECTION TAILLES
                VStack(alignment: .leading, spacing: 12) {
                    Text("Taille :")
                        .font(.body)
                        .fontWeight(.regular)
                    
                    HStack(spacing: 12) {
                        ForEach(sizes, id: \.self) { size in
                            Button(action: {
                                selectedSize = size
                            }) {
                                Text(size)
                                    .font(.body)
                                    .fontWeight(.regular)
                                    .frame(width: 50, height: 40)
                                    .background(selectedSize == size ? Color.black : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedSize == size ? .white : .black)
                                    .cornerRadius(8)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // BOUTON AJOUTER AU PANIER
                Button(action: {
                    print("Produit ajouté au panier, taille : \(selectedSize ?? "Aucune")")
                }) {
                    Text("Ajouter au panier")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) // Espace pour la tab bar
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}

