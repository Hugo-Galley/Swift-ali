//
//  HomeView.swift
//  swift-ali
//
//  Created by Hugo Galley on 02/10/2025.
//

import SwiftUI

struct HomeView : View {
    
    let products = [
        (image: "psg", title: "PSG Domicile 24/25", price: "89,99 €"),
        (image: "real", title: "Real Madrid Extérieur", price: "84,99 €"),
        (image: "barca", title: "Barça Third", price: "79,99 €"),
        (image: "bayern", title: "Bayern Domicile", price: "89,99 €"),
    ]
    
    let collumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    var body: some View {
        ScrollView{
            LazyVGrid(columns: collumns, spacing: 16){
                ForEach(products, id: \.title){ product in
                    NavigationLink(destination: ProductSelectionView(imageName: product.image, title: product.title, price: product.price, sizes: ["S","M","L","XL"])){
                        CardView(
                            imageName: product.image,
                            title: product.title,
                            price: product.price
                        )
                    }
                    .foregroundColor(.black)
                    
                }
            }
            .padding()
        }
    }
}
