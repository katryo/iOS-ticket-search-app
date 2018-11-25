//
//  Artist.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/24.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import Foundation

class Artist: Codable {
    let name: String
    let followers: String
    let popularity: Int
    let url: URL
    let images: [URL]
}
