import Foundation

struct Product: Identifiable, Equatable {
    let id = UUID()
    let image: String
    let title: String
    let price: Double
    let size: String?
    
}
