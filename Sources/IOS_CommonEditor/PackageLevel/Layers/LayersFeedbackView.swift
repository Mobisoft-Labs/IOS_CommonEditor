import UIKit

final class LayersFeedbackView: UIView {
    private let titleLabel = UILabel()
    private let noButton = UIButton(type: .system)
    private let yesButton = UIButton(type: .system)

    var onYes: (() -> Void)?
    var onNo: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .secondarySystemBackground
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = ""

        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.setTitle("", for: .normal)
        noButton.backgroundColor = UIColor.systemGray6
        noButton.layer.cornerRadius = 18
        noButton.addTarget(self, action: #selector(noTapped), for: .touchUpInside)

        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.setTitle("", for: .normal)
        yesButton.backgroundColor = UIColor.systemBlue
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.layer.cornerRadius = 18
        yesButton.addTarget(self, action: #selector(yesTapped), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(noButton)
        addSubview(yesButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            yesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            yesButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            yesButton.widthAnchor.constraint(equalToConstant: 84),
            yesButton.heightAnchor.constraint(equalToConstant: 40),

            noButton.trailingAnchor.constraint(equalTo: yesButton.leadingAnchor, constant: -10),
            noButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            noButton.widthAnchor.constraint(equalToConstant: 72),
            noButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configure(designSystem: LayersDesignSystem, prompt: String, yesTitle: String, noTitle: String) {
        titleLabel.text = prompt
        yesButton.setTitle(yesTitle, for: .normal)
        noButton.setTitle(noTitle, for: .normal)
        titleLabel.textColor = designSystem.primaryText
        titleLabel.font = designSystem.subtitleFont
        noButton.backgroundColor = UIColor.systemGray6
        noButton.setTitleColor(designSystem.primaryText, for: .normal)
        noButton.titleLabel?.font = designSystem.buttonFont
        yesButton.backgroundColor = designSystem.accentColor
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.titleLabel?.font = designSystem.buttonFont
    }

    @objc private func yesTapped() {
        onYes?()
    }

    @objc private func noTapped() {
        onNo?()
    }
}
