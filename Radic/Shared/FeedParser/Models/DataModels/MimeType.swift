//
//  MimeType.swift
//  Radic
//
//  Created by Ivan Kovacevic on 30.06.2021..
//

import Foundation

/// Just a handful of supported mime types for images
///
/// Specification:
/// https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
enum MimeType: String, CaseIterable {
    case png = "image/png"
    case jpeg = "image/jpeg"
    case gif = "image/gif"
    case bmp = "image/bmp"
    case ico = "image/vnd.microsoft.icon"
    case tiff = "image/tiff"
}
