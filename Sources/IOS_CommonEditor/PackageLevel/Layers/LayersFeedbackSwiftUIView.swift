import SwiftUI

struct LayersFeedbackSwiftUIView: View {
    let prompt: String
    let yesTitle: String
    let noTitle: String
    let promptFont: UIFont
    let buttonFont: UIFont
    let primaryText: UIColor
    let accentColor: UIColor
    let secondaryText: UIColor
    let onYes: () -> Void
    let onNo: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(prompt)
                .font(Font(promptFont))
                .foregroundColor(Color(primaryText))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer(minLength: 12)
            Button(action: onNo) {
                Text(noTitle)
                    .font(Font(buttonFont))
                    .foregroundColor(Color(primaryText))
                    .frame(width: 72, height: 40)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(18)
            }
            Button(action: onYes) {
                Text(yesTitle)
                    .font(Font(buttonFont))
                    .foregroundColor(Color.white)
                    .frame(width: 84, height: 40)
                    .background(Color(accentColor))
                    .cornerRadius(18)
            }
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(18)
    }
}
