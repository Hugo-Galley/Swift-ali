import Combine
import SwiftUI

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    /// Charge tous les maillots
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await apiService.fetchJerseys()
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    /// Charge les maillots d'une équipe spécifique
    func loadProducts(forTeam team: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await apiService.fetchJerseys(forTeam: team)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    /// Recherche des maillots
    func searchProducts(query: String) async {
        guard !query.isEmpty else {
            await loadProducts()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            products = try await apiService.searchJerseys(query: query)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}

