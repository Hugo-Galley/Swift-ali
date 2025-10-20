import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var cart: CartViewModel

    @State private var orders: [Order] = []

    var body: some View {
        VStack {
            if orders.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "shippingbox")
                        .font(.system(size: 70))
                        .foregroundColor(.gray)
                    Text("Aucune commande pour le moment")
                        .font(.headline)
                    Text("Vos commandes apparaîtront ici")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            } else {
                List(orders) { order in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Commande #\(order.id)")
                                    .font(.headline)
                                    .foregroundColor(.psgBlue)
                                Text("Date : \(formatted(date: order.orderDate))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.2f €", order.total))
                                .font(.title3)
                                .bold()
                                .foregroundColor(.psgBlue)
                        }
                        
                        if let delivery = order.deliveryDate {
                            HStack {
                                Image(systemName: "truck.box")
                                    .foregroundColor(.green)
                                Text("Livraison estimée : \(formatted(date: delivery))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Divider()
                        
                        // Items
                        Text("Articles :")
                            .font(.subheadline)
                            .bold()
                        
                        ForEach(order.items()) { cartItem in
                            HStack(spacing: 12) {
                                Image(cartItem.product.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(cartItem.product.name)
                                        .font(.subheadline)
                                        .lineLimit(2)
                                    Text("Taille: \(cartItem.selectedSize)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text(String(format: "%.2f €", cartItem.price))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Mes commandes")
        .onAppear(perform: loadOrders)
    }

    private func loadOrders() {
        guard let user = auth.currentUser else {
            orders = []
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let fetched = DatabaseManager.shared.getOrders(forUser: user.id)
            DispatchQueue.main.async {
                orders = fetched
            }
        }
    }

    private func formatted(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        fmt.locale = Locale(identifier: "fr_FR")
        return fmt.string(from: date)
    }
}
