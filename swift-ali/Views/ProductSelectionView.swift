import SwiftUI

struct ProductSelectionView: View {
    var imageName: String
    var title: String
    var price: String
    var sizes: [String]

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
                
                Text(title)
                    .font(.title2)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Text("Prix : \(price)")
                    .font(.body)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Taille :")
                        .font(.body)
                    
                    HStack(spacing: 12) {
                        ForEach(sizes, id: \.self) { size in
                            Button(action: {
                                selectedSize = size
                            }) {
                                Text(size)
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
                
                Button(action: {
                    if let size = selectedSize,
                       let priceValue = Double(price.replacingOccurrences(of: "€", with: "")
                                                    .replacingOccurrences(of: ",", with: ".")
                                                    .trimmingCharacters(in: .whitespaces)) {
                        let product = Product(image: imageName, title: title, price: priceValue, size: size)
                        cart.addToCart(product)
                        print(" Produit ajouté : \(title), taille : \(size)")
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Ajouter au panier")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selectedSize == nil ? Color.gray : Color.psgBlue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                .disabled(selectedSize == nil)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
    }
}
