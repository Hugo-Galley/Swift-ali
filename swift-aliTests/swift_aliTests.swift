//
//  swift_aliTests.swift
//  swift-aliTests
//
//  Created by Hugo Galley on 02/10/2025.
//

import Testing
import Foundation
@testable import swift_ali

// MARK: - Test 1 : Création et manipulation d'un Product
struct ProductTests {
    
    @Test("Test 1: Créer un Product et vérifier ses propriétés")
    func testCreateProduct() {
        // Créer un produit
        let product = Product(
            id: 1,
            name: "Maillot FC Barcelona",
            team: "FC Barcelona",
            price: 89.99,
            description: "Maillot officiel",
            image: "barca",
            sizes: ["S", "M", "L"],
            stock: 50,
            category: "Domicile"
        )
        
        // Vérifications
        #expect(product.id == 1)
        #expect(product.name == "Maillot FC Barcelona")
        #expect(product.price == 89.99)
        #expect(product.sizes.count == 3)
        #expect(product.title == "Maillot FC Barcelona") // Vérifier la propriété calculée
    }
}

// MARK: - Test 2 : Panier d'achat (CartViewModel)
@MainActor
struct CartTests {
    
    @Test("Test 2: Ajouter des produits au panier et calculer le total")
    func testCartOperations() {
        // Créer un panier vide
        let cart = CartViewModel()
        #expect(cart.items.isEmpty)
        #expect(cart.total == 0)
        
        // Créer des produits
        let product1 = Product(
            id: 1, name: "Maillot PSG", team: "PSG", price: 50.00,
            description: "Test", image: "psg", sizes: ["M"],
            stock: 10, category: "Domicile"
        )
        let product2 = Product(
            id: 2, name: "Maillot Real", team: "Real", price: 30.00,
            description: "Test", image: "real", sizes: ["L"],
            stock: 10, category: "Domicile"
        )
        
        // Ajouter au panier
        cart.addToCart(product1, size: "M")
        cart.addToCart(product2, size: "L")
        
        // Vérifications
        #expect(cart.items.count == 2)
        #expect(cart.total == 80.00)
        #expect(cart.items[0].selectedSize == "M")
        #expect(cart.items[1].selectedSize == "L")
        
        // Vider le panier
        cart.clearCart()
        #expect(cart.items.isEmpty)
        #expect(cart.total == 0)
    }
}

// MARK: - Test 3 : CartItem et encodage JSON
struct CartItemTests {
    
    @Test("Test 3: Créer un CartItem et vérifier l'encodage/décodage JSON")
    func testCartItemJSON() throws {
        // Créer un produit et un CartItem
        let product = Product(
            id: 1, name: "Maillot Bayern", team: "Bayern", price: 89.99,
            description: "Test", image: "bayern", sizes: ["M"],
            stock: 10, category: "Domicile"
        )
        let cartItem = CartItem(product: product, selectedSize: "M")
        
        // Vérifications de base
        #expect(cartItem.selectedSize == "M")
        #expect(cartItem.price == 89.99)
        
        // Encoder en JSON
        let encoder = JSONEncoder()
        let data = try encoder.encode(cartItem)
        #expect(data.count > 0)
        
        // Décoder depuis JSON
        let decoder = JSONDecoder()
        let decodedItem = try decoder.decode(CartItem.self, from: data)
        
        // Vérifications après décodage
        #expect(decodedItem.selectedSize == "M")
        #expect(decodedItem.product.name == "Maillot Bayern")
        #expect(decodedItem.price == 89.99)
    }
}
