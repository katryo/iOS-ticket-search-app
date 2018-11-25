//
//  UpcomingEvent.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/25.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import Foundation

class UpcomingEvent: Codable {
    let name: String
    let url: URL
    let artistName: String
    let type: String
    let time: String
    let unixtime: Int
}
