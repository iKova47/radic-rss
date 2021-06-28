//
//  FeedUpdateProgressView.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import UIKit

final class FeedUpdateProgressView: BaseView {

    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override var intrinsicContentSize: CGSize {
        CGSize(width: 150, height: 30)
    }

    override func setup() {
        addSubview(progressView)
        addSubview(label)
    }

    override func constrainSubviews() {
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10),

            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -4)
        ])
    }

    func set(progress: Float, formattedProgress: String) {
        label.text = formattedProgress
        progressView.progress = progress
    }
}
