//
//  InsetsLabel.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

/// Label implementation which allows setting custom insets for the label text.
final class InsetsLabel: UILabel {

    var contentEdgeInsets: UIEdgeInsets = .zero

    override  func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.contentEdgeInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(
            width: size.width + contentEdgeInsets.left + contentEdgeInsets.right,
            height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom
        )
    }
}
