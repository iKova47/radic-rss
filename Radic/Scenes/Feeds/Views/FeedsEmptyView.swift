//
//  FeedsEmptyView.swift
//  Radic
//
//  Created by Ivan Kovacevic on 13.07.2021..
//

import UIKit

final class FeedsEmptyView: BaseView {

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.text = #"Tap on the "+" button to add a new feed"#
        return label
    }()

    override func setup() {
        addSubview(label)
    }

    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Spacing.xl),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Spacing.xl)
        ])
    }
}
