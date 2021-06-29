//
//  FeedCell.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

final class FeedCell: BaseTableViewCell {

    private let favIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()

    private let labelsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    private let unreadCountLabel: UILabel = {
        let label = InsetsLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 12)
        label.backgroundColor = Colors.accentColor
        label.contentEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        label.textAlignment = .center
        return label
    }()

    // MARK: -  Lifecycle
    override func setup() {
        contentView.addSubview(favIconImageView)
        contentView.addSubview(labelsStackView)
        contentView.addSubview(unreadCountLabel)

        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
    }

    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            favIconImageView.topAnchor.constraint(equalTo: labelsStackView.topAnchor, constant: 4),
            favIconImageView.heightAnchor.constraint(equalToConstant: 16),
            favIconImageView.widthAnchor.constraint(equalTo: favIconImageView.heightAnchor),
            favIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            labelsStackView.leadingAnchor.constraint(equalTo: favIconImageView.trailingAnchor, constant: 8),
            labelsStackView.trailingAnchor.constraint(lessThanOrEqualTo: unreadCountLabel.leadingAnchor, constant: -8),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            unreadCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            unreadCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            unreadCountLabel.widthAnchor.constraint(greaterThanOrEqualTo: unreadCountLabel.heightAnchor)
        ])
    }

    func configure(with viewModel: FeedViewModel) {
        
        if let favIconURL = viewModel.faviconURL {
            favIconImageView.load(favIcon: favIconURL, placeholder: Images.placeholder)
        } else {
            favIconImageView.image = Images.placeholder
        }

        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        unreadCountLabel.text = viewModel.numberOfUnreadItemsFormatted
        unreadCountLabel.isHidden = viewModel.numberOfUnreadItems == 0
    }
}
