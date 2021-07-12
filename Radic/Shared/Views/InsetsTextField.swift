//
//  InsetsTextField.swift
//  Radic
//
//  Created by Ivan Kovacevic on 12.07.2021..
//

import UIKit

/// `UITextField` implementation which allows setting custom insets for the text.
final class InsetsTextField: UITextField {

    var textPadding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

