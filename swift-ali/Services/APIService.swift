import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    // Simule un délai réseau (entre 0.5 et 1.5 secondes)
    private func simulateNetworkDelay() async {
        let delay = Double.random(in: 0.5...1.5)
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
    
    /// Récupère tous les maillots depuis le fichier JSON local
    func fetchJerseys() async throws -> [Product] {
        // Simule un délai réseau
        await simulateNetworkDelay()
        
        // Charge le fichier JSON local
        guard let url = Bundle.main.url(forResource: "jerseys", withExtension: "json") else {
            throw APIError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let products = try decoder.decode([Product].self, from: data)
        
        return products
    }
    
    /// Récupère les maillots d'une équipe spécifique
    func fetchJerseys(forTeam team: String) async throws -> [Product] {
        let allJerseys = try await fetchJerseys()
        return allJerseys.filter { $0.team == team }
    }
    
    /// Récupère les maillots par catégorie
    func fetchJerseys(byCategory category: String) async throws -> [Product] {
        let allJerseys = try await fetchJerseys()
        return allJerseys.filter { $0.category == category }
    }
    
    /// Récupère un maillot par son ID
    func fetchJersey(byId id: Int) async throws -> Product? {
        let allJerseys = try await fetchJerseys()
        return allJerseys.first { $0.id == id }
    }
    
    /// Recherche des maillots par nom
    func searchJerseys(query: String) async throws -> [Product] {
        let allJerseys = try await fetchJerseys()
        let lowercasedQuery = query.lowercased()
        return allJerseys.filter { 
            $0.name.lowercased().contains(lowercasedQuery) || 
            $0.team.lowercased().contains(lowercasedQuery)
        }
    }
}

// Erreurs possibles de l'API
enum APIError: Error, LocalizedError {
    case fileNotFound
    case invalidData
    case decodingError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Le fichier de données n'a pas été trouvé"
        case .invalidData:
            return "Les données reçues sont invalides"
        case .decodingError:
            return "Erreur lors du décodage des données"
        case .networkError:
            return "Erreur de connexion réseau"
        }
    }
}
