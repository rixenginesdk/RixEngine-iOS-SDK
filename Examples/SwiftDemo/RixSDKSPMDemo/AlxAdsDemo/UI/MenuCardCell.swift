//
//  MenuCardCell.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

class MenuCardCell: UITableViewCell {

    static let reuseID = "MenuCardCell"

    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor(red: 0.45, green: 0.45, blue: 0.65, alpha: 0.08).cgColor
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        l.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        l.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.6, alpha: 1)
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let chevron: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let img = UIImage(systemName: "chevron.right", withConfiguration: config)
        let iv = UIImageView(image: img)
        iv.tintColor = UIColor(red: 0.75, green: 0.75, blue: 0.8, alpha: 1)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setContentHuggingPriority(.required, for: .horizontal)
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descLabel)
        cardView.addSubview(chevron)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -12),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -12),
            descLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),

            chevron.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, description: String) {
        titleLabel.text = title
        descLabel.text = description
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowPath = UIBezierPath(
            roundedRect: cardView.bounds,
            cornerRadius: cardView.layer.cornerRadius
        ).cgPath
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.15) {
            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            self.cardView.alpha = highlighted ? 0.85 : 1
        }
    }
}

// MARK: - PaddingLabel

class PaddingLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 16, height: size.height + 4)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 8, dy: 2))
    }
}
