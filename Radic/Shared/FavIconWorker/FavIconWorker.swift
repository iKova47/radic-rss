//
//  FavIconWorker.swift
//  RSSReader
//
//  Created by Ivan Kovacevic on 26.06.2021..
//

import Foundation
import UIKit

/// This class is intended only for downloading favIcons which are usually very small in size
final class FavIconWorker {

    static let shared = FavIconWorker()

    private init() {}

    /// Function for fetching favIcon from the web or from the cache
    ///
    /// - Parameters:
    ///   - url: An URL to the favicon
    ///   - completion: Completes with an `UIImage` instance of the favIcon
    func fetch(from url: URL, completion: @escaping (UIImage?) -> Void) {

        if let cached = fetchCachedImage(for: url) {
            completion(cached)

        } else {
            download(from: url, completion: completion)
        }
    }

    /// Function for downloading the content of the url.
    /// After the image has been downloaded, the function will cache the result and
    /// complete with an instance of the `UIImage`.
    ///
    /// - Parameters:
    ///   - url: The destination of favIcon
    ///   - completion: Completes with an `UIImage` instance of the favIcon
    private func download(from url: URL, completion: @escaping (UIImage?) -> Void) {

        URLSession.shared.downloadTask(with: url) { [weak self] tempURL, _, _ in

            guard let tempURL = tempURL else {
                // Don't care for the response or the error
                return
            }

            guard let data = try? Data(contentsOf: tempURL) else {
                // Don't care for the data error
                return
            }

            let image = UIImage(data: data)

            if image != nil {
                self?.cache(data: data, for: url)
            }

            DispatchQueue.main.async {
                completion(image)
            }
        }
        .resume()
    }

    // MARK: - Cache handling

    /// This function will write the content of the `data` to the cacheURL
    /// The cache has no expiration date!
    ///
    /// - Parameters:
    ///   - data: Data we want to cache
    ///   - url: An url where from the data came
    private func cache(data: Data, for url: URL) {

        createCacheFolderIfNeeded()

        do {
            try data.write(to: createCacheURL(from: url))
            Log.info("Successfully cached image")

        } catch {
            Log.error("Failed to cache image", error: error)
        }
    }

    /// Function for fetching favIcon from the local storage
    ///
    /// - Parameter url: The remote URL of the image, used for the name of a cached file.
    /// - Returns: An instance of `UIImage` or nil
    private func fetchCachedImage(for url: URL) -> UIImage? {

        let cachedURL = createCacheURL(from: url)

        guard let data = try? Data(contentsOf: cachedURL) else {
            return nil
        }

        return UIImage(data: data)
    }

    /// Creates the `favIconCache` folder inside of the documents directory of the app
    /// or returns if the folder already exists
    private func createCacheFolderIfNeeded() {

        var isDir: ObjCBool = ObjCBool(false)

        let exists = FileManager.default.fileExists(atPath: cacheFolder.absoluteString, isDirectory: &isDir)

        guard !exists && !isDir.boolValue else {
            return
        }

        try? FileManager.default.createDirectory(at: cacheFolder, withIntermediateDirectories: true)
    }

    // MARK: Cache URL
    /// This function takes a remote URL of the favIcon and returns the local URL of the cached file.
    /// The url may or may not exist on the disk.
    ///
    /// - Parameter url: The remote URL of the favIcon
    /// - Returns: A local URL of the possible location for the cached file.
    func createCacheURL(from url: URL) -> URL {
        let name = url.host ?? "favIcon"
        return cacheFolder.appendingPathComponent(name).appendingPathExtension("ico")
    }

    /// URL to the `favIconCache` subfolder, located in the documents directory
    var cacheFolder: URL {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var url = URL(fileURLWithPath: path, isDirectory: true)
        url.appendPathComponent("favIconCache")

        return url
    }
}
