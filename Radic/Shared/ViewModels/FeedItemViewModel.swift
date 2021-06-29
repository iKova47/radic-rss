//
//  FeedItemViewModel.swift
//  Radic
//
//  Created by Ivan Kovacevic on 28.06.2021..
//

import Foundation

struct FeedItemViewModel: Hashable {
    
    let item: Item
    let title: String
    let description: String?
    let creator: String?
    let isRead: Bool
    let dateString: String?
    
    var url: URL? {
        guard let link = item.link else {
            return nil
        }
        
        return URL(string: link)
    }
    
    init(item: Item) {
        self.item = item
        title = item.title ?? "Unnamed"
        description = item.desc
        creator = item.creator
        isRead = item.isRead
        
        if let pubDate = item.pubDate {
            let formatter = Calendar.current.isDateInToday(pubDate) ?
                DateFormatter.timeShort :
                DateFormatter.monthAndDay
            
            dateString = formatter.string(from: pubDate)
            
        } else {
            dateString = nil
        }
    }
}
