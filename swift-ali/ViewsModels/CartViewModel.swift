import Foundation
import Combine


class CartViewModel: ObservableObject {
    @Published var items: [Product] = []
    
    var total: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    func addToCart(_ product: Product) {
        items.append(product)
    }
    
    func removeFromCart(_ product: Product) {
        items.removeAll { $0.id == product.id }
    }
    
    func clearCart() {
        items.removeAll()
    }
}
