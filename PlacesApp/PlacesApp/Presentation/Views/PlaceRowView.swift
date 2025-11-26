import SwiftUI

struct PlaceRowView: View {
    let place: Place
    
    var body: some View {
        HStack(spacing: 12) {
            // Location icon
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundColor(AppTheme.accentColor)
                .accessibilityHidden(true)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(place.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let description = place.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(AppTheme.secondaryText)
                        .lineLimit(2)
                }
                
                HStack(spacing: 6) {
                    Label(String(format: "%.4f", place.latitude), systemImage: "location.circle.fill")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    Label(String(format: "%.4f", place.longitude), systemImage: "location.circle.fill")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
            
            Spacer()
            
            // Chevron indicator
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
                .accessibilityHidden(true)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: AppTheme.cardShadow, radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
        .accessibilityHint("Opens Wikipedia at this location")
    }
    
    private var accessibilityText: String {
        var text = place.displayName
        
        if let desc = place.description {
            text += ", \(desc)"
        }
        
        text += ", latitude \(place.latitude), longitude \(place.longitude)"
        return text
    }
}
