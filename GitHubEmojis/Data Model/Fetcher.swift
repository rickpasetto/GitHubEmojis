//
//  Fetcher.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import Foundation

enum FetchError {
    
    /// Failed to fetch the data over HTTP
    // TODO: store HTTP error?
    case HttpFetchFailed
    
    /// Failed to parse JSON data
    case ParseFailed
}

typealias ResponseHandler = (
    
    /// Called on a successful fetch completion, complete with list of Emojis
    /// Guaranteed to be called on main thread
    onFetchComplete: (_ emojis: [Emoji]) -> Void,
    
    /// Called on an unsuccessful fetch completion
    /// Guaranteed to be called on main thread
    onFetchError: (_ error: FetchError) -> Void
)

class Fetcher {
    
    let url: URL

    /// Create a fetcher for emojis based on a URL
    init(url: URL) {
        self.url = url
    }
    
    /// Initiate the fetch
    func fetch(handler: ResponseHandler) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                if error == nil {
                    
                    if let emojis = self.parseJson(data) {
                        
                        DispatchQueue.main.async {
                            handler.onFetchComplete(emojis)
                        }
                    } else {
                        DispatchQueue.main.async {
                            handler.onFetchError(.ParseFailed)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        handler.onFetchError(.HttpFetchFailed)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    handler.onFetchError(.HttpFetchFailed)
                }
            }
        }
        task.resume()
    }

    private func parseJson(_ data: Data) -> [Emoji]? {
        
        do {
            if let parsedJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] {

//                var result: [Emoji] = []
//                
//                for (key, value) in parsedJson.sorted(by: { $0 < $1 }) {
//                    result.append(Emoji(name: key, url: URL(string: value)!))
//                }
//                
//                return result
                
                return parsedJson.sorted(by: { $0 < $1 }).map { Emoji(name: $0, url: URL(string: $1)!) }
                
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
