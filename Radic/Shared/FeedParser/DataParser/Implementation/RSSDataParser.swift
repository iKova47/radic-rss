//
//  ChannelModelParser.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 25.06.2021..
//

import Foundation
import Combine

/// This is very simple RSS data parser implementation
/// It could probably be better implemented using keyPaths
/// But I don't have time atm to do it that way
final class RSSDataParser: NSObject, DataParser {

    enum RSS {
        enum Channel {
            static let root = "channel"
            static let lastBuildDate = "lastBuildDate"
            static let image = "image"
            static let title = "title"
            static let link = "link"
            static let description = "description"
        }

        enum Image {
            static let root = "image"
            static let url = "url"
            static let title = "title"
            static let link = "link"
        }

        enum Item {
            static let root = "item"
            static let pubDate = "pubDate"
            static let creator = "dc:creator"
            static let author = "author"
            static let guid = "guid"
            static let title = "title"
            static let link = "link"
            static let description = "description"
        }

        enum Enclosure {
            static let root = "enclosure"
            static let url = "url"
            static let type = "type"
            static let length = "length"
        }
    }

    private let parser: XMLParser
    private var channel: ChannelModel?
    private var image: ImageModel?
    private var enclosure: EnclosureModel?
    private var currentItem: ItemModel?

    private var currentElementName: String?

    private let q = DispatchQueue(label: "com.radic.parser.rss")
    private let subject = PassthroughSubject<ChannelModel, DataParseError>()

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

    func parse() -> AnyPublisher<ChannelModel, DataParseError> {
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
        case RSS.Channel.root:
            channel = ChannelModel()

        case RSS.Image.root:
            image = ImageModel()

        case RSS.Item.root:
            currentItem = ItemModel()

        case RSS.Enclosure.root:
            enclosure = EnclosureModel()
            enclosure?.url = attributeDict[RSS.Enclosure.url] ?? ""
            enclosure?.type = attributeDict[RSS.Enclosure.type] ?? ""

            let length = attributeDict[RSS.Enclosure.length] ?? "0"
            enclosure?.length = Int(length) ?? 0

        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        switch elementName {
        case RSS.Item.root:
            if let item = currentItem {
                channel?.items.append(item)
                currentItem = nil
            }

        case RSS.Enclosure.root:
            currentItem?.enclosure = enclosure
            enclosure = nil

        case RSS.Image.root:
            channel?.image = image
            image = nil

        case RSS.Channel.description, RSS.Item.description:
            // Descriptions for some feeds can be quite big.
            // We don't care for the long descriptions, since we are only
            // displaying them in 2 rows, so we will limit their character count to max value of 100
            if let item = currentItem {
                item.desc = String(item.desc?.prefix(100) ?? "").removingHTMLElements()

            } else {
                channel?.desc = String(channel?.desc?.prefix(100) ?? "").removingHTMLElements()
            }

        default:
            break
        }

        currentElementName = nil
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {

        let value = string.trimmingCharacters(in: .whitespacesAndNewlines).xmlUnescaped()

        guard !value.isEmpty else {
            return
        }

        if let item = currentItem {
            assignToItem(value: value, item: item)

        } else {
            if let image = image {
                assignToChannelImage(value: value, image: image)

            } else {
                assignToChannelModel(value: value)
            }
        }
    }

    // MARK: - Errors
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        #warning("Handle this error")
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        #warning("Handle this error")
    }
}

// MARK: - Assignment
private extension RSSDataParser {

    func assignToItem(value: String, item: ItemModel) {

        switch currentElementName {
        case RSS.Item.title:
            let title = item.title ?? ""
            item.title = title + value
        case RSS.Item.description:
            let desc = item.desc ?? ""
            item.desc = desc + value
        case RSS.Item.link:
            item.link = value
        case RSS.Item.pubDate:
            item.pubDate = dateFormatter.date(from: value)
        case RSS.Item.creator, RSS.Item.author:
            item.author = value
        case RSS.Item.guid:
            item.guid = value
        default:
            break
        }
    }

    /// Assign given value to the `ChannelModel`
    /// We only care for title, description and link
    func assignToChannelModel(value: String) {

        switch currentElementName {
        case RSS.Channel.title:
            channel?.title = value
        case RSS.Channel.description:
            channel?.desc = value
        case RSS.Channel.link:
            channel?.link = value
        case RSS.Channel.lastBuildDate:
            channel?.lastBuildDate = dateFormatter.date(from: value)
        default:
            break
        }
    }

    func assignToChannelImage(value: String, image: ImageModel) {

        switch currentElementName {
        case RSS.Image.link:
            image.link = value
        case RSS.Image.title:
            image.title = value
        case RSS.Image.url:
            image.url = value
        default:
            break
        }
    }
}
