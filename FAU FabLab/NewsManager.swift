//
//  NewsManager.swift
//  FAU FabLab
//
//  Created by Max Jalowski on 25.07.15.
//  Copyright (c) 2015 FAU MAD FabLab. All rights reserved.
//

import UIKit

var newsMgr: NewsManager = NewsManager()

struct newsEntry {
    var title = "Title"
    var desc = "Description Blah Blah"
}

class NewsManager: NSObject {
    
    var news = [newsEntry]()
    
    override init() {
        super.init()
        addNews("News 1", desc: "Description 1 blah blah blah")
        addNews("News 2", desc: "Description 2 blah blah blah")
        addNews("News 3", desc: "Description 3 blah blah blah")
        addNews("News 4", desc: "Description 4 blah blah blah")
        addNews("News 5", desc: "Description 5 blah blah blah")
        addNews("News 6", desc: "Description 6 blah blah blah")
        addNews("News 7", desc: "Description 7 blah blah blah")
    }
    
    func addNews(title: String, desc: String) {
        news.append(newsEntry(title: title, desc: desc))
    }
    
}

