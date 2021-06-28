//
//  FeedItemsPresenter.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//


import UIKit

protocol FeedItemsPresentationLogic {
    func present(title: String, favIcon: UIImage?)
    
}

final class FeedItemsPresenter: FeedItemsPresentationLogic {
    weak var viewController: FeedItemsDisplayLogic?

    func present(title: String, favIcon: UIImage?) {
        viewController?.display(title: createAttributedTitle(from: title, image: favIcon))
    }

    /// Creates an `NSAttributedString` which contains the image on the left side
    /// and the text on the right side.
    /// The image and the text are separated by a single whitespace
    ///
    /// - Parameters:
    ///   - image: An image we want to display as part of the text
    ///   - title: Text for the title
    /// - Returns: An attributed string which contains the leading image and the text
    private func createAttributedTitle(from text: String, image: UIImage?) -> NSAttributedString {

        let titleFont = UIFont.boldSystemFont(ofSize: 18)

        // Text
        let attributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: UIColor.darkText
        ]

        let title = NSAttributedString(string: " " + text, attributes: attributes)

        guard let image = image else {
            return title
        }

        // Attachment
        let attachment = NSTextAttachment()
        attachment.image = image

        let aspect = image.size.width / image.size.height
        let height: CGFloat = 20
        let width = aspect * height

        let bounds = CGRect(
            x: 0,
            y: (titleFont.capHeight - height).rounded() / 2,
            width: width,
            height: height
        )

        attachment.bounds = bounds
        let attachmentTitle = NSMutableAttributedString(attachment: attachment)

        attachmentTitle.append(title)

        return attachmentTitle
    }
}
