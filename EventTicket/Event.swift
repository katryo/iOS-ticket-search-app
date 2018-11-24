//
//  Event.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/19.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import Foundation

class Event: Codable {
    let name: String
    let id: String
    let artistNames: [String]
    let priceRange: String
    let ticketStatus: String
    let url: URL
    let seatmap: URL
//    let images: [URL]
    let date: String
    let time: String
    let llTime: String
    let venueName: String
    let segment: String
    let genre: String
    let subGenre: String
    let categoryString: String
    
//    init(name: String, address: String) {
//        self.name = name
//       // self.address = address
//    }
}
