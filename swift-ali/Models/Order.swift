import Foundation

struct Order: Identifiable {
    let id: Int64
    let userId: Int64
    let itemsJSON: String // JSON representation of cart items
    let total: Double
    let orderDate: Date
    let deliveryDate: Date?

    // Helper to decode itemsJSON into [CartItem]
    func items() -> [CartItem] {
        guard let data = itemsJSON.data(using: .utf8) else { return [] }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([CartItem].self, from: data)
        } catch {
            print("❌ Erreur de décodage des items de commande: \(error)")
            return []
        }
    }
}
