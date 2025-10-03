import SwiftUI

struct CardView: View {
    var imageName: String
    var title: String
    var price: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 150) 
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)

            Text(title)
                .font(.headline)
                .lineLimit(1)
                .colorScheme(.dark)

            Text(price)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

