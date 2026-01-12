import UIKit

final class DropIndicatorView: UIView {
    private let titleLabel = UILabel()
    private let dashedLayer = CAShapeLayer()

    var accentColor: UIColor = .blue {
        didSet {
            updateColors()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        layer.addSublayer(dashedLayer)
        dashedLayer.fillColor = UIColor.clear.cgColor
        dashedLayer.lineWidth = 1.5
        dashedLayer.lineDashPattern = [6, 4]
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.text = "DROP HERE"
        titleLabel.textAlignment = .center
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
        let inset: CGFloat = 0.5
        let rect = bounds.insetBy(dx: inset, dy: inset)
        dashedLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: height / 2).cgPath
        titleLabel.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }

    private func updateColors() {
        titleLabel.textColor = accentColor
        dashedLayer.strokeColor = accentColor.withAlphaComponent(0.7).cgColor
    }
}
