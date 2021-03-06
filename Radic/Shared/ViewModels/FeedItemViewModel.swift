//
//  FeedItemViewModel.swift
//  Radic
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import Foundation

struct FeedItemViewModel: Hashable {
    
    let item: ItemModel
    let title: String
    let description: String?
    let author: String?
    let isRead: Bool
    let dateString: String?
    let imageURL: URL?
    
    var url: URL? {
        guard let link = item.link else {
            return nil
        }
        
        return URL(string: link)
    }
    
    init(item: ItemModel, isRead: Bool) {
        self.item = item
        title = item.title ?? "Unnamed"
        description = item.desc
        author = item.author
        self.isRead = isRead
        
        if let pubDate = item.pubDate {
            let formatter = Calendar.current.isDateInToday(pubDate) ?
                DateFormatter.timeShort :
                DateFormatter.monthAndDay
            
            dateString = formatter.string(from: pubDate)
            
        } else {
            dateString = nil
        }

        if
            let enclosure = item.enclosure,
            MimeType.allCases.contains(where: { $0.rawValue == enclosure.type })
        {
            imageURL = URL(string: enclosure.url)

        } else {
            imageURL = nil
        }
    }
}
