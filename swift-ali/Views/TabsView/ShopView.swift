import SwiftUI

struct ShopView: View {
    @EnvironmentObject var cart: CartViewModel
    @EnvironmentObject var auth: AuthViewModel
    @State private var showOrderSuccess = false
    
    var body: some View {
        VStack {
            if cart.items.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "cart")
                        .font(.system(size: 70))
                        .foregroundColor(.gray)
                    Text("🛒 Votre panier est vide")
                        .font(.headline)
                    Text("Ajoutez des maillots depuis la boutique")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                List {
                    ForEach(cart.items) { cartItem in
                        HStack {
                            Image(cartItem.product.image)
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
                        indexSet.map { cart.items[$0] }.forEach(cart.removeFromCart)
                    }
                }
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Total :")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "%.2f €", cart.total))
                            .font(.title3)
                            .bold()
                            .foregroundColor(.psgBlue)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        // Commander : persister commande, vider panier et afficher popup
                        cart.placeOrder(forUserId: auth.currentUser?.id) { success in
                            if success {
                                showOrderSuccess = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Commander")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.psgBlue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .alert("Commande passée !", isPresented: $showOrderSuccess) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Votre commande a bien été enregistrée. Vous pouvez la consulter dans 'Mes commandes'.")
                    }
                }
            }
        }
        .navigationTitle("Mon Panier")
    }
}
