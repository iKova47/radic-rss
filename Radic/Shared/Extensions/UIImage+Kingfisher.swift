//
//  UIImage+FavIcon.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit
import Kingfisher

extension UIImageView {


    /// Uses the `FavIconWorker` to fetch the available favIcon for a given url
    /// - Parameters:
    ///   - url: The url of the `favIcon`
    ///   - placeholder: The placeholder to use while the image is loading 
    func load(url: URL, placeholder: UIImage?, size: CGSize) {

        let processor = DownsamplingImageProcessor(size: size)

        kf.setImage(
            with: url,
            placeholder: placeholder,
            options:
                [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                ]
        )
    }
}
