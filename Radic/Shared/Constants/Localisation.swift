//
//  Localisation.swift
//  Radic
//
//  Created by Ivan Kovacevic on 13.07.2021..
//

import Foundation

enum Localisation {

    enum Feeds {
        static let empyMessage = "feeds.emptyMessage".localised
        static let title = "feeds.title".localised

        enum Alert {
            static let cancel = "feeds.alert.cancel".localised
            static let rename = "feeds.alert.rename".localised
            static let remove = "feeds.alert.remove".localised
            static let removeMessage = "feeds.alert.removeMessage".localised
        }
    }

    enum NoSelection {
        static let message = "noSelection.message".localised
    }

    enum ContextMenu {
        static let markRead = "contextMenu.markRead".localised
        static let markUnread = "contextMenu.markUnread".localised
        static let openInBrowser = "contextMenu.openBrowser".localised
        static let share = "contextMenu.share".localised

        static let openHomepage = "contextMenu.openHomepage".localised
        static func markAllRead(in value: String) -> String {
            String(format: "contextMenu.markALlRead".localised, value)
        }

        static let rename = "contextMenu.rename".localised
        static let remove = "contextMenu.remove".localised
    }

    enum AddFeed {

        static let title = "addFeed.title".localised
        
        enum TextField {
            static let titlePlaceholder = "addFeed.textField.title".localised
            static let urlPlaceholder = "addFeed.textField.url".localised
        }

        enum Button {
            static let add = "addFeed.button.add".localised
            static let cancel = "addFeed.button.cancel".localised
        }
    }

    enum Alert {
        static let actionButton = "alert.actionButton".localised

        static let errorTitle = "alert.errorTitle".localised
        static let warningTitle = "alert.warningTitle".localised
        static let failureTitle = "alert.failureTitle".localised
    }

    enum Error {
        static let alreadyAdded = "error.alreadyAdded".localised
        static let invalidURL = "error.invalidURL";
        static func failed(reason: String) -> String {
            String(format: "error.failedWithReason".localised, reason)
        }

        enum Reason {
            static let notValidRSSURL = "error.reason.notValidRSSURL".localised// = "The feed URL must be a valid RSS feed URL";
            static let invalidURLFormat = "error.reason.invalidURLFormat".localised //= "The URL is not in the correct format";
            static let offline = "error.reason.offline".localised //= "The internet connection appears to be offline";
            static let mustBeHTTPS = "error.reason.mustBeHTTPS".localised //= "The URL must be secure HTTPS URL";

        }
    }
}

extension String {

    var localised: String {
        NSLocalizedString(self, comment: "")
    }

}
