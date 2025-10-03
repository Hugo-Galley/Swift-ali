//
//  MainView.swift
//  swift-ali
//
//  Created by Hugo Galley on 02/10/2025.
//
import SwiftUI

struct MainView : View {
    var body : some View{
        HeaderView(logoName: "icon", appName: "Retailler")
        TabView{
            NavigationStack{
                HomeView()
            }
            .tabItem{
                Label("Home", systemImage: "house")
            }
            
            NavigationStack{
                ShopView()
            }
            .tabItem{
                Label("Panier", systemImage: "bag")
            }
            
            NavigationStack{
                AccountView()
            }
            .tabItem{
                Label("Compte", systemImage: "person.crop.circle")
            }
            
        }
    }
}
