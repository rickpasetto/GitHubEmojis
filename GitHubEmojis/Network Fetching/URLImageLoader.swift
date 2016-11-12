//
//  URLImageLoader.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import Foundation
import UIKit

/// Class that manages loading Images asynchronously from URLs, governed by a key per load.  
/// Loads for the same key are cancelled automatically so as not to call the same handler twice.
class URLImageLoader {

    var loadsInProgress: [ Int: URLFetcher ] = [:]

    func load(imageUrl: URL, forKey key: Int, handler: @escaping (_ image: UIImage?)->Void) {

        synchronize(self.loadsInProgress) {
            if let fetcher = self.loadsInProgress[key] {
                fetcher.cancel()
                self.loadsInProgress.removeValue(forKey: key)
            }
        }

        let fetcher = URLFetcher(url: imageUrl)
        
        synchronize(self.loadsInProgress) {
            self.loadsInProgress[key] = fetcher
        }

        fetcher.fetch((
            onFetchComplete: { data in
                synchronize(self.loadsInProgress) {
                    if let inProgress = self.loadsInProgress[key], inProgress === fetcher {
                        handler(UIImage(data: data))
                        self.loadsInProgress.removeValue(forKey: key)
                    }
                }
        },
            onFetchError: { _ in
                synchronize(self.loadsInProgress) {
                    if let inProgress = self.loadsInProgress[key], inProgress === fetcher {
                        handler(nil)
                        self.loadsInProgress.removeValue(forKey: key)
                    }
                }
        }))
    }

}
