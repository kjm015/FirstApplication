//
//  SongFeed.swift
//  FirstApplication
//
//  Created by Kevin Miyata on 9/21/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import Foundation

struct SongFeed: Decodable {
    var feed: Feed
}

struct Feed: Decodable {
    var results: [Result]
}

struct Result: Decodable {
    var artistName: String
    var name: String
    var releaseDate: String
}
