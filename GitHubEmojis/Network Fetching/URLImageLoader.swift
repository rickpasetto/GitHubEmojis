//
//  URLImageLoader.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import Foundation
import UIKit

class URLImageLoader {

    static func load(imageUrl: URL, handler: @escaping (_ image: UIImage?)->Void) {
        let fetcher = URLFetcher(url: imageUrl)

        fetcher.fetch((
            onFetchComplete: { data in
                handler(UIImage(data: data))
        },
            onFetchError: { _ in
                handler(nil)
        }))
    }

}
