//
//  ChannelParser.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import Combine

final class RSSDataParser: NSObject, DataParser {

    enum Tag {
        enum Channel {
            static let root = "channel"
            static let lastBuildDate = "lastBuildDate"
        }

        enum Item {
            static let root = "item"
            static let pubDate = "pubDate"
            static let creator = "dc:creator"
            static let author = "author"
            static let image = "image"
            static let guid = "guid"
        }

        // Shared names between the `Channel` and the `Item`
        static let title = "title"
        static let link = "link"
        static let description = "description"
    }

    private let parser: XMLParser
    private var channel: Channel?
    private var currentItem: Item?

    private var currentElementName: String?

    private let q = DispatchQueue(label: "com.rssparser.parser")
    private let subject = PassthroughSubject<Channel, DataParseError>()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()

    // MARK: - Lifecycle
    init(data: Data) {
        self.parser = XMLParser(data: data)
        super.init()
        configureParser()
    }

    func parse() -> AnyPublisher<Channel, DataParseError> {
        q.async {
            self.parser.parse()
        }

        return subject
            .eraseToAnyPublisher()
    }

    private func configureParser() {
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
    }
}

// MARK: - XMLParserDelegate
extension RSSDataParser: XMLParserDelegate {

    func parserDidEndDocument(_ parser: XMLParser) {

        if let channel = self.channel {
            self.subject.send(channel)
            self.subject.send(completion: .finished)

        } else {
            self.subject.send(completion: .failure(.noData))
        }

        self.channel = nil
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        currentElementName = elementName

        switch elementName {
        case Tag.Channel.root:
            self.channel = Channel()

        case Tag.Item.root:
            self.currentItem = Item()

        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == Tag.Item.root {
            if let item = currentItem {
                channel?.items.append(item)
                currentItem = nil
            } else {
                #warning("Log error here")
            }
        }

        currentElementName = nil
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {

        let string = string.trimmingCharacters(in: .whitespacesAndNewlines).xmlUnescaped()

        guard !string.isEmpty else {
            return
        }

        if currentItem != nil {
            assignToItem(value: string)
        } else {
            assignToChannel(value: string)
        }
    }

    // MARK: - Errors
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {

    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {

    }
}

// MARK: - Assignment
private extension RSSDataParser {

    func assignToItem(value: String) {

        guard let item = currentItem else {
            return
        }

        switch currentElementName {
        case Tag.title:
            let title = item.title ?? ""
            item.title = title + value
        case Tag.description:
            let desc = item.desc ?? ""
            item.desc = desc + value
        case Tag.link:
            item.link = value
        case Tag.Item.pubDate:
            item.pubDate = dateFormatter.date(from: value)
        case Tag.Item.creator, Tag.Item.author:
            item.creator = value
        case Tag.Item.image:
            item.image = value
        case Tag.Item.guid:
            item.guid = value
        default:
            break
        }
    }

    /// Assign given value to the `Channel`
    /// We only care for title, description and link
    func assignToChannel(value: String) {

        switch currentElementName {
        case Tag.title:
            channel?.title = value
        case Tag.description:
            channel?.desc = value
        case Tag.link:
            channel?.link = value
        case Tag.Channel.lastBuildDate:
            channel?.lastBuildDate = dateFormatter.date(from: value)
        default:
            break
        }
    }
}
