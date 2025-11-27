import SwiftUI

struct PlaceRowView: View {
    let place: Place
    var onActivate: (() -> Void)? = nil
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
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppTheme.secondaryText)
                .accessibilityHidden(true)
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: AppTheme.cardShadow, radius: 5, x: 0, y: 2)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(rowAccessibilityLabel)
        .accessibilityValue(rowAccessibilityValue)
        .accessibilityHint("Opens details about this location on Wikipedia")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: "Open Wikipedia") {
            onActivate?()
        }
    }
    
    private var latitudeFormatted: String {
        String(format: "%.2f", place.latitude)
    }
    
    private var longitudeFormatted: String {
        String(format: "%.2f", place.longitude)
    }
    
    internal var rowAccessibilityLabel: String {
        place.displayName
    }
    
    internal var rowAccessibilityValue: String {
        var parts: [String] = []
        
        if let desc = place.description {
            parts.append(desc)
        }

        parts.append("Latitude \(latitudeFormatted)")
        parts.append("Longitude \(longitudeFormatted)")
        
        return parts.joined(separator: ", ")
    }
}
