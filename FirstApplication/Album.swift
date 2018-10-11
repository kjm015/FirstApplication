//
//  Album.swift
//  FirstApplication
//
//  Created by Kevin Miyata on 10/9/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import Foundation

class Album {
    var title: String = ""
    var link: String = ""
    var category: String = ""
    var description: String = ""
    var pubDate: String = ""
    
    init(title: String, link: String, category: String, description: String) {
        self.title = title
        self.link = link
        self.category = category
        self.description = description
    }
}
