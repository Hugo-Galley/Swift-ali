//
//  HeaderView.swift
//  swift-ali
//
//  Created by Hugo Galley on 03/10/2025.
//

import SwiftUI

struct HeaderView : View {
    var logoName: String
    var appName: String
    
    var body: some View {
        HStack(spacing : 12){
            Image(logoName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Text(appName)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .shadow(radius: 1)
        
    }
}
