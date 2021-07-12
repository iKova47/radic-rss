//
//  FeedItemCell.swift
//  Radic
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import UIKit

final class FeedItemCell: BaseTableViewCell {

    private enum Constants {
        static let imageViewSize = CGSize(width: 50, height: 50)
    }

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

    private let creatorAndDateStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()

    // This stack view holds the `titleDescriptionStackView` and `creatorAndDateLabel`
    private let labelsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

    private let imageViewStackView: UIStackView = {
        let view = UIStackView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.alignment = .top
        return view
    }()

    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    // This stack view holds the `labelsStackView` and the imageView
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
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
        contentView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(labelsStackView)
        contentStackView.addArrangedSubview(imageViewStackView)
        imageViewStackView.addArrangedSubview(itemImageView)

        labelsStackView.addArrangedSubview(titleDescriptionStackView)
        titleDescriptionStackView.addArrangedSubview(titleLabel)
        titleDescriptionStackView.addArrangedSubview(descriptionLabel)

        labelsStackView.addArrangedSubview(creatorAndDateStackView)
        creatorAndDateStackView.addArrangedSubview(authorLabel)
        creatorAndDateStackView.addArrangedSubview(dateLabel)

        labelsStackView.setCustomSpacing(6, after: titleDescriptionStackView)

        contentView.addSubview(readIndicatorView)
    }

    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            readIndicatorView.widthAnchor.constraint(equalToConstant: 10),
            readIndicatorView.heightAnchor.constraint(equalTo: readIndicatorView.widthAnchor),
            readIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.m),
            readIndicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.m),

            contentStackView.leadingAnchor.constraint(equalTo: readIndicatorView.trailingAnchor, constant: Spacing.m),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.m),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.s),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.s),

            imageViewStackView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize.width),
            itemImageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize.height)
        ])
    }

    func configure(with viewModel: FeedItemViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        authorLabel.text = viewModel.author
        readIndicatorView.isHidden = viewModel.isRead
        dateLabel.text = viewModel.dateString

        if let url = viewModel.imageURL {
            itemImageView.load(url: url, placeholder: Images.placeholderLarge, size: Constants.imageViewSize)
        }

        imageViewStackView.isHidden = viewModel.imageURL == nil
    }
}
