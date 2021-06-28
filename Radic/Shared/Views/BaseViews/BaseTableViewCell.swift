//
//  BaseTableViewCell.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

/// A custom base class for helping when writing UI programmatically
open class BaseTableViewCell: UITableViewCell {

    private var didConstrainSubviews = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
}
