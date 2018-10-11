//
//  SongFeed.swift
//  XMLApplication
//
//  Created by Kevin Miyata on 9/21/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import Foundation

struct SongFeed: Decodable {
    var feed: Feed
}

struct Feed: Decodable {
    var results: [Song]
}

struct Song: Decodable {
    var artistName: String
    var id: String
    var releaseDate: String
    var name: String
    var artworkUrl100: String
}

struct ShowData: Decodable {
    //let name: String
    //let summary: String
    let feed: Feed
}
