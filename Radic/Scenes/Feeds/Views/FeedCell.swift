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
        contentView.addSubview(titleLabel)
        contentView.addSubview(unreadCountLabel)
    }

    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            favIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favIconImageView.heightAnchor.constraint(equalToConstant: 16),
            favIconImageView.widthAnchor.constraint(equalTo: favIconImageView.heightAnchor),
            favIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            titleLabel.leadingAnchor.constraint(equalTo: favIconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: unreadCountLabel.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            unreadCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            unreadCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
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
        unreadCountLabel.text = viewModel.numberOfUnreadItemsFormatted
        unreadCountLabel.isHidden = viewModel.numberOfUnreadItems == 0
    }
}
