import SwiftUI

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(AppTheme.secondaryText)
                .accessibilityHidden(true)
            
            Text(message)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: onRetry) {
                Text("button.retry")
                    .font(.system(size: 17, weight: .semibold))
            }
            .buttonStyle(.borderedProminent)
            .accessibilityLabel(LocalizedStrings.accessibilityRetry)
            .accessibilityHint(LocalizedStrings.accessibilityRetryHint)
            .accessibilityIdentifier("RetryButton")
            .accessibilityAddTraits(.isButton)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .contain)
    }
}

