//
//  UIImage+FavIcon.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import UIKit

extension UIImageView {

    func load(favIcon url: URL, placeholder: UIImage?) {
        self.image = placeholder

        FavIconWorker.shared.fetch(from: url) { [weak self] image in
            guard let image = image else {
                return
            }

            self?.image = image
        }
    }
}
