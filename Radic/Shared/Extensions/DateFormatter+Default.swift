//
//  DateFormatter+Default.swift
//  Radic
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import Foundation

extension DateFormatter {

    static let monthAndDay: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "MMM dd"
        return formater
    }()
}
