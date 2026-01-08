import UIKit

final class DropIndicatorView: UIView {
    private let highlightView = UIView()
    private let lineView = UIView()
    private let titleLabel = UILabel()

    var accentColor: UIColor = .blue {
        didSet {
            updateColors()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(highlightView)
        addSubview(lineView)
        addSubview(titleLabel)
        highlightView.layer.cornerRadius = 6
        highlightView.clipsToBounds = true
        lineView.layer.cornerRadius = 2
        lineView.clipsToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.text = "Drop Here"
        titleLabel.textAlignment = .left
        backgroundColor = .clear
        updateColors()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColors()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let height = bounds.height
        highlightView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        lineView.frame = CGRect(x: 0, y: height - 4, width: width, height: 4)
        titleLabel.frame = CGRect(x: 8, y: 0, width: max(0, width - 16), height: height - 4)
    }

    private func updateColors() {
        highlightView.backgroundColor = accentColor.withAlphaComponent(0.12)
        lineView.backgroundColor = accentColor
        titleLabel.textColor = accentColor
    }
}
