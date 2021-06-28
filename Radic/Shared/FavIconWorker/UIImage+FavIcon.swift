//
//  UIImage+FavIcon.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

extension UIImageView {


    /// Uses the `FavIconWorker` to fetch the available favIcon for a given url
    /// - Parameters:
    ///   - url: The url of the `favIcon`
    ///   - placeholder: The placeholder to use while the image is loading 
    func load(favIcon url: URL, placeholder: UIImage?) {
        image = placeholder

        FavIconWorker.shared.fetch(from: url) { [weak self] image in
            guard let image = image else {
                return
            }

            self?.image = image
        }
    }
}
