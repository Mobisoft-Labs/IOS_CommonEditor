import UIKit
import SwiftUI

struct LayersDesignSystem {
    let accentColor: UIColor
    let backgroundColor: UIColor
    let cardColor: UIColor
    let cardBorder: UIColor
    let primaryText: UIColor
    let secondaryText: UIColor
    let separator: UIColor
    let selectedRowBackground: UIColor
    let selectedRowBorder: UIColor
    let chipBackground: UIColor
    let chipTextColor: UIColor
    let chipBorder: UIColor
    let dragHandleColor: UIColor
    let lockTint: UIColor
    let orderText: UIColor
    let thumbnailBackground: UIColor
    let guideLineColor: UIColor
    let groupChipBackground: UIColor
    let groupChipText: UIColor
    let groupChipBorder: UIColor
    let stickerChipBackground: UIColor
    let stickerChipText: UIColor
    let stickerChipBorder: UIColor
    let textChipBackground: UIColor
    let textChipText: UIColor
    let textChipBorder: UIColor

    let titleFont: UIFont
    let subtitleFont: UIFont
    let buttonFont: UIFont
    let orderFont: UIFont
    let chipFont: UIFont
    let headerFont: UIFont
    let headerActionFont: UIFont

    let cardCornerRadius: CGFloat
    let chipCornerRadius: CGFloat
    let rowHeight: CGFloat
    let cardBorderWidth: CGFloat
    let selectionBorderWidth: CGFloat

    init(config: LayersConfiguration) {
        accentColor = config.accentColorUIKit
        backgroundColor = UIColor.systemBackground
        cardColor = UIColor.secondarySystemBackground
        cardBorder = UIColor.systemGray5
        primaryText = UIColor.label
        secondaryText = UIColor.secondaryLabel
        separator = UIColor.separator
        selectedRowBackground = accentColor.withAlphaComponent(0.12)
        selectedRowBorder = accentColor.withAlphaComponent(0.35)
        chipBackground = UIColor.systemBlue
        chipTextColor = UIColor.white
        chipBorder = UIColor.systemBlue.withAlphaComponent(0.35)
        dragHandleColor = UIColor.systemGray2
        lockTint = UIColor.systemGray2
        orderText = UIColor.secondaryLabel
        thumbnailBackground = UIColor.systemGray6
        guideLineColor = UIColor.systemGray4
        groupChipBackground = UIColor.systemBlue.withAlphaComponent(0.12)
        groupChipText = UIColor.systemBlue
        groupChipBorder = UIColor.systemBlue.withAlphaComponent(0.35)
        stickerChipBackground = UIColor.systemOrange.withAlphaComponent(0.12)
        stickerChipText = UIColor.systemOrange
        stickerChipBorder = UIColor.systemOrange.withAlphaComponent(0.35)
        textChipBackground = UIColor.systemIndigo.withAlphaComponent(0.12)
        textChipText = UIColor.systemIndigo
        textChipBorder = UIColor.systemIndigo.withAlphaComponent(0.35)

        titleFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
        subtitleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        buttonFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        orderFont = UIFont.systemFont(ofSize: 11, weight: .semibold)
        chipFont = UIFont.systemFont(ofSize: 11, weight: .bold)
        headerFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerActionFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cardCornerRadius = 18
        chipCornerRadius = 10
        rowHeight = 72
        cardBorderWidth = 1
        selectionBorderWidth = 1.5
    }
}
