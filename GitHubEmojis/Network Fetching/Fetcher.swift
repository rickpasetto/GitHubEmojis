//
//  Fetcher.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import Foundation

enum FetchError {
    
    /// HTTP Error occurred
    case HttpError(Int)

    /// Some kind of network error
    case NetworkError(Error)

    /// No data was returned
    case NoData
}

typealias ResponseHandler = (
    
    /// Called on a successful fetch completion
    /// Guaranteed to be called on main thread
    onFetchComplete: (_ data: Data) -> Void,
    
    /// Called on an unsuccessful fetch completion
    /// Guaranteed to be called on main thread
    onFetchError: (_ error: FetchError) -> Void
)

protocol Fetcher {

    /// Initiate an asynchronous fetch.  The response will be called on ResponseHandler
    func fetch(_ handler: ResponseHandler)

    /// Cancel a previously initiated fetch.
    func cancel() 
}

class URLFetcher: Fetcher {
    
    private let url: URL
    private var sessionTask: URLSessionTask?

    /// Create a fetcher for emojis based on a URL
    init(url: URL) {
        self.url = url
    }
    
    /// Initiate the fetch
    func fetch(_ handler: ResponseHandler) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            if let error = error {
                DispatchQueue.main.async {
                    handler.onFetchError(.NetworkError(error))
                }
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    handler.onFetchError(.HttpError(response.statusCode))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    handler.onFetchError(.NoData)
                }
                return
            }

            DispatchQueue.main.async {
                handler.onFetchComplete(data)
            }
        }

        self.sessionTask = task
        task.resume()
    }

    /// Cancel the fetch
    func cancel() {
        self.sessionTask?.cancel()
    }
}
