import Foundation

struct Product: Identifiable, Equatable, Codable {
    let id: Int
    let name: String
    let team: String
    let price: Double
    let description: String
    let image: String
    let sizes: [String]
    let stock: Int
    let category: String
    
    // Pour la compatibilité avec l'ancien code
    var title: String { name }
    
    // CodingKeys pour le décodage JSON
    enum CodingKeys: String, CodingKey {
        case id, name, team, price, description, image, sizes, stock, category
    }
}
