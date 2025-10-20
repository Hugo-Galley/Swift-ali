import Foundation
import Combine

// Représente un article dans le panier avec la taille sélectionnée
struct CartItem: Identifiable, Equatable, Codable {
    let id: UUID
    let product: Product
    let selectedSize: String
    
    var price: Double { product.price }
    
    init(product: Product, selectedSize: String) {
        self.id = UUID()
        self.product = product
        self.selectedSize = selectedSize
    }
}

class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    
    var total: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    func addToCart(_ product: Product, size: String) {
        let cartItem = CartItem(product: product, selectedSize: size)
        items.append(cartItem)
    }
    
    func removeFromCart(_ cartItem: CartItem) {
        items.removeAll { $0.id == cartItem.id }
    }
    
    func clearCart() {
        items.removeAll()
    }

    /// Place an order for the current items. Requires a userId (nil -> guest, will not persist)
    /// Returns true on success via completion handler.
    func placeOrder(forUserId userId: Int64?, completion: @escaping (Bool) -> Void) {
        guard !items.isEmpty else {
            completion(false)
            return
        }

        // Prepare JSON - encode the cart items
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(items), let json = String(data: data, encoding: .utf8) else {
            completion(false)
            return
        }

        let totalValue = total
        let orderDate = Date()
        // Example: delivery date +7 days
        let deliveryDate = Calendar.current.date(byAdding: .day, value: 7, to: orderDate)

        // If no userId, we don't persist but still clear cart locally
        guard let uid = userId else {
            DispatchQueue.main.async {
                self.items.removeAll()
                completion(true)
            }
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            DatabaseManager.shared.insertOrder(userId: uid, itemsJSON: json, total: totalValue, orderDate: orderDate, deliveryDate: deliveryDate)
            DispatchQueue.main.async {
                self.items.removeAll()
                completion(true)
            }
        }
    }
}
