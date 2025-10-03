//
//  AccountView.swift
//  swift-ali
//
//  Created by Hugo Galley on 02/10/2025.
//

import SwiftUI

struct AccountView : View {
    @State private var isDarkMode = false
    var body: some View {
        VStack{
            Image("profilPhoto")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 1)
                )
                .shadow(radius: 3)
                .padding()
            
            Text("Hugo Galley")
                .font(.title2)
                .padding(30)

            VStack(spacing : 15){
                Text("Adresse email : hugo.galley@ecoles-epsi.net")
                
                        .font(.title3)
                    Toggle(isOn: $isDarkMode){
                        Text("Mode sombre")
                            .font(.headline)
                    }
                    .padding(30)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
           

            
        }
        .padding()
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
