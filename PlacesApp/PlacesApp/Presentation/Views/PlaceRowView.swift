import SwiftUI

struct PlaceRowView: View {
    let place: Place
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.displayName)
                .font(.headline)
            
            if let description = place.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                Label(String(format: "%.4f", place.latitude), systemImage: "location.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("•")
                    .foregroundColor(.secondary)
                Label(String(format: "%.4f", place.longitude), systemImage: "location.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }
    
    private var accessibilityText: String {
        var text = place.displayName
        
        if let desc = place.description { text += ", \(desc)" }
        
        text += ", latitude \(place.latitude), longitude \(place.longitude)"
        return text
    }
}
