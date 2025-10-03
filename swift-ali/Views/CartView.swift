import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: CartViewModel
    
    var body: some View {
        VStack {
            if cart.items.isEmpty {
                Text(" Votre panier est vide")
                    .font(.headline)
                    .padding()
            } else {
                List {
                    ForEach(cart.items) { product in
                        HStack {
                            Image(product.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(product.title)
                                    .font(.headline)
                                if let size = product.size {
                                    Text("Taille : \(size)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                            
                            Text("\(product.price, specifier: "%.2f") €")
                                .font(.subheadline)
                                .bold()
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.map { cart.items[$0] }.forEach(cart.removeFromCart)
                    }
                }
                
                HStack {
                    Text("Total :")
                        .font(.headline)
                    Spacer()
                    Text("\(cart.total, specifier: "%.2f") €")
                        .font(.title3)
                        .bold()
                }
                .padding()
                
                Button(action: {
                    print("Passer la commande")
                }) {
                    Text("Commander")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Mon Panier")
    }
}
