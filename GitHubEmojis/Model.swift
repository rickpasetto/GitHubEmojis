//
//  Model.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import Foundation

class Model {

    private let fetcher: Fetcher
    /// Note: Assumption made in this exercise that the number of Emojis is relatively small, and
    /// keeping around a full list is reasonable.
    private var emojis: [Emoji] = []

    init(fetcher: Fetcher) {

        self.fetcher = fetcher
    }

    func refreshData(dataReady: @escaping () -> Void, dataError: @escaping (_ message: String) -> Void) {

        self.fetcher.fetch((
            onFetchComplete: { data in
                if let emojis = self.parseJson(data) {
                    self.emojis = emojis
                    dataReady()
                } else {
                    dataError("Error parsing JSON")
                }
        },
            onFetchError: { error in
                dataError("Error loading: \(error)")
        }))
    }

    var count: Int { return emojis.count }

    subscript(index:Int) -> Emoji {
        get {
            return emojis[index]
        }
    }

    private func parseJson(_ data: Data) -> [Emoji]? {

        do {
            if let parsedJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] {

                return parsedJson.sorted(by: { $0 < $1 }).map { Emoji(name: $0, url: URL(string: $1)!) }

            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

}
