//
//  FeedItemCell.swift
//  Radic
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import UIKit

final class FeedItemCell: BaseTableViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 2
        return label
    }()

    private let titleDescriptionStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()

    private let creatorAndDateLabel: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()

    private let mainStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

    private let readIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.accentColor
        view.layer.cornerRadius = 5
        return view
    }()

    // MARK: - Lifecycle
    override func setup() {
        contentView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(titleDescriptionStackView)
        titleDescriptionStackView.addArrangedSubview(titleLabel)
        titleDescriptionStackView.addArrangedSubview(descriptionLabel)

        mainStackView.addArrangedSubview(creatorAndDateLabel)
        creatorAndDateLabel.addArrangedSubview(authorLabel)
        creatorAndDateLabel.addArrangedSubview(dateLabel)

        mainStackView.setCustomSpacing(6, after: titleDescriptionStackView)

        contentView.addSubview(readIndicatorView)
    }

    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            readIndicatorView.widthAnchor.constraint(equalToConstant: 10),
            readIndicatorView.heightAnchor.constraint(equalTo: readIndicatorView.widthAnchor),
            readIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            readIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            mainStackView.leadingAnchor.constraint(equalTo: readIndicatorView.trailingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with viewModel: FeedItemViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        authorLabel.text = viewModel.author
        readIndicatorView.isHidden = viewModel.isRead
        dateLabel.text = viewModel.dateString
    }
}
