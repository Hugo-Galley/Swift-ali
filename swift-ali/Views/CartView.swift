import SwiftUI

struct CartView: View {
    @EnvironmentObject var cart: CartViewModel
    @EnvironmentObject var auth: AuthViewModel
    @State private var showOrderPlaced = false
    
    var body: some View {
        VStack {
            if cart.items.isEmpty {
                Text(" Votre panier est vide")
                    .font(.headline)
                    .padding()
            } else {
                List {
                    ForEach(cart.items) { cartItem in
                        HStack {
                            Image(cartItem.product.image, bundle: .main)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(cartItem.product.name)
                                    .font(.headline)
                                    .lineLimit(2)
                                Text("Taille : \(cartItem.selectedSize)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.2f €", cartItem.price))
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.psgBlue)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            cart.removeFromCart(cart.items[index])
                        }
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
                    // Place order
                    cart.placeOrder(forUserId: auth.currentUser?.id) { success in
                        if success {
                            showOrderPlaced = true
                        }
                    }
                }) {
                    Text("Commander")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .alert("Commande passée", isPresented: $showOrderPlaced) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Votre commande a bien été enregistrée. Vous pouvez la consulter dans Mes commandes.")
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Mon Panier")
    }
}
