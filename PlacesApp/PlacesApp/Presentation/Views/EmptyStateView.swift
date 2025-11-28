import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.secondaryText)
                .accessibilityHidden(true)
            
            Text("message.no.places.found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(LocalizedStrings.accessibilityNoPlacesFound)
        .accessibilityAddTraits(.isStaticText)
    }
}


