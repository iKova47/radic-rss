//
//  BaseCollectionViewCell.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

/// A custom base class for helping when writing UI programmatically
open class BaseCollectionViewCell: UICollectionViewCell {

    private var didConstrainSubviews = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setNeedsUpdateConstraints()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Use this function to setup the subviews and configure view
    func setup() {}

    /// Use this function to setup the constraints for the subview
    func constrainSubviews() {}

    open override func updateConstraints() {
        defer {
            super.updateConstraints()
        }

        guard !didConstrainSubviews else {
            return
        }

        didConstrainSubviews = true
        constrainSubviews()
    }

    // Sometimes the `UICollectionViewCompositionalLayout` needs a little help to determine the correct size of the cell
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        layoutIfNeeded()

        layoutAttributes.frame.size = systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return layoutAttributes
    }
}
