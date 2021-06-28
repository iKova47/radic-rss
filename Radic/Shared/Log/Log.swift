//
//  Log.swift
//  Radic
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import OSLog

final class Log {

    enum Subsystem {
        static let main = "com.radic.rss"
    }

    public enum Category: String {
        case main = "APP"
        case api = "API"
        case backgroundTask = "BG TASK"
        case feeds = "FEEDS"
    }

    private static let logger = Logger(subsystem: Subsystem.main, category: "")

    static func info(_ value: String, category: Category = .main) {
        let logger = Logger(subsystem: Subsystem.main, category: category.rawValue)
        logger.log(level: .info, "💚 \(value)")
    }

    static func debug(_ value: String, category: Category = .main) {
        let logger = Logger(subsystem: Subsystem.main, category: category.rawValue)
        logger.log(level: .debug, "🐞 \(value)")
    }

    static func error(_ value: String, error: Error?, category: Category = .main) {
        let logger = Logger(subsystem: Subsystem.main, category: category.rawValue)

        var message = "\(value)"
        
        if let error = error {
            message += " error: \(error.localizedDescription)"
        }

        logger.log(level: .error, "❤️‍🩹 \(message)")
    }

    static func fault(_ value: String, category: Category = .main) {
        let logger = Logger(subsystem: Subsystem.main, category: category.rawValue)
        logger.log(level: .fault, "💔 \(value)")
    }
}
