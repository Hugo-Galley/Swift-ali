import SwiftUI

// EXEMPLE D'UTILISATION DE L'API
// Ce fichier montre différentes façons d'utiliser l'APIService

struct ExampleAPIUsageView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var selectedTeam: String = "Toutes les équipes"
    
    let teams = ["Toutes les équipes", "FC Barcelona", "Paris Saint-Germain", "Real Madrid", "Bayern Munich"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Sélecteur d'équipe
                Picker("Équipe", selection: $selectedTeam) {
                    ForEach(teams, id: \.self) { team in
                        Text(team)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: selectedTeam) { oldValue, newValue in
                    Task {
                        if newValue == "Toutes les équipes" {
                            await viewModel.loadProducts()
                        } else {
                            await viewModel.loadProducts(forTeam: newValue)
                        }
                    }
                }
                
                // État de chargement
                if viewModel.isLoading {
                    ProgressView("Chargement...")
                        .padding()
                }
                
                // Message d'erreur
                if let error = viewModel.errorMessage {
                    Text("Erreur: \(error)")
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Liste des produits
                List(viewModel.products) { product in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(product.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .font(.headline)
                                Text(product.team)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(String(format: "%.2f €", product.price))
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Text("\(product.stock) en stock")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Text(product.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        HStack {
                            ForEach(product.sizes, id: \.self) { size in
                                Text(size)
                                    .font(.caption)
                                    .padding(4)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Exemple API")
            .task {
                await viewModel.loadProducts()
            }
        }
    }
}

// EXEMPLE DE FONCTIONS DIRECTES AVEC L'API

class ExampleAPIService {
    
    // Exemple 1: Charger tous les maillots
    static func example1_fetchAll() async {
        do {
            let jerseys = try await APIService.shared.fetchJerseys()
            print("✅ \(jerseys.count) maillots récupérés")
            jerseys.forEach { jersey in
                print("  - \(jersey.name): \(jersey.price)€")
            }
        } catch {
            print("❌ Erreur: \(error.localizedDescription)")
        }
    }
    
    // Exemple 2: Charger les maillots d'une équipe
    static func example2_fetchByTeam() async {
        do {
            let jerseys = try await APIService.shared.fetchJerseys(forTeam: "FC Barcelona")
            print("✅ \(jerseys.count) maillots du Barça trouvés")
        } catch {
            print("❌ Erreur: \(error.localizedDescription)")
        }
    }
    
    // Exemple 3: Chercher un maillot spécifique
    static func example3_fetchById() async {
        do {
            if let jersey = try await APIService.shared.fetchJersey(byId: 1) {
                print("✅ Maillot trouvé: \(jersey.name)")
                print("   Prix: \(jersey.price)€")
                print("   Tailles: \(jersey.sizes.joined(separator: ", "))")
                print("   Stock: \(jersey.stock)")
            }
        } catch {
            print("❌ Erreur: \(error.localizedDescription)")
        }
    }
    
    // Exemple 4: Recherche
    static func example4_search() async {
        do {
            let results = try await APIService.shared.searchJerseys(query: "Domicile")
            print("✅ \(results.count) résultats pour 'Domicile'")
            results.forEach { jersey in
                print("  - \(jersey.name)")
            }
        } catch {
            print("❌ Erreur: \(error.localizedDescription)")
        }
    }
    
    // Exemple 5: Filtrer par catégorie
    static func example5_fetchByCategory() async {
        do {
            let jerseys = try await APIService.shared.fetchJerseys(byCategory: "Maillot Extérieur")
            print("✅ \(jerseys.count) maillots extérieurs")
        } catch {
            print("❌ Erreur: \(error.localizedDescription)")
        }
    }
    
    // Exemple 6: Utilisation dans une fonction asynchrone avec gestion d'erreur
    static func example6_withErrorHandling() async -> [Product] {
        do {
            return try await APIService.shared.fetchJerseys()
        } catch APIError.fileNotFound {
            print("❌ Fichier JSON introuvable")
            return []
        } catch APIError.decodingError {
            print("❌ Erreur de décodage des données")
            return []
        } catch {
            print("❌ Erreur inconnue: \(error)")
            return []
        }
    }
    
    // Exemple 7: Charger et filtrer localement
    static func example7_customFilter() async {
        do {
            let allJerseys = try await APIService.shared.fetchJerseys()
            
            // Filtrer les maillots à moins de 90€
            let affordableJerseys = allJerseys.filter { $0.price < 90 }
            print("✅ \(affordableJerseys.count) maillots à moins de 90€")
            
            // Filtrer les maillots en stock limité
            let limitedStock = allJerseys.filter { $0.stock < 40 }
            print("✅ \(limitedStock.count) maillots en stock limité")
            
            // Grouper par équipe
            let groupedByTeam = Dictionary(grouping: allJerseys, by: { $0.team })
            print("✅ Maillots par équipe:")
            groupedByTeam.forEach { team, jerseys in
                print("   \(team): \(jerseys.count) maillots")
            }
        } catch {
            print("❌ Erreur: \(error.localizedDescription)")
        }
    }
}

// Pour tester les exemples, appelez-les dans une Task:
/*
Task {
    await ExampleAPIService.example1_fetchAll()
    await ExampleAPIService.example2_fetchByTeam()
    await ExampleAPIService.example3_fetchById()
    await ExampleAPIService.example4_search()
    await ExampleAPIService.example5_fetchByCategory()
    let products = await ExampleAPIService.example6_withErrorHandling()
    await ExampleAPIService.example7_customFilter()
}
*/
