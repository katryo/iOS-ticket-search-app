//
//  RootNavigationController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    var favoriteEventList: EventList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let json: [String: [Event]] = ["events": []]
        let emptyData = try? JSONEncoder().encode(json)
        
        favoriteEventList = try? JSONDecoder().decode(EventList.self, from: emptyData!)

        let data = UserDefaults.standard.data(forKey: "favoriteEvents")
        if data != nil {
            let eventsList = try? JSONDecoder().decode(EventList.self, from: data!)
            if eventsList != nil {
                favoriteEventList = eventsList
            }
        }
    }
    
    func hasFavorited(event: Event) -> Bool {
        for favorited in favoriteEventList!.events {
            if favorited === event {
                return true
            }
        }
        return false
    }
    
    func removeFavorite(event: Event) {
        for (i, favoriteEvent) in favoriteEventList!.events.enumerated() {
            if favoriteEvent === event {
                favoriteEventList!.events.remove(at: i)
            }
        }
        
        let data = try? JSONEncoder().encode(favoriteEventList)
        UserDefaults.standard.set(data, forKey:"favoriteEvents")
    }
    
    func addFavorites(event: Event) {
        favoriteEventList!.events.append(event)
        
        let data = try? JSONEncoder().encode(favoriteEventList)
        UserDefaults.standard.set(data, forKey:"favoriteEvents")
    }
    
    
    func updateFavorites(event: Event) {
        var found = false
        for (i, favoriteEvent) in favoriteEventList!.events.enumerated() {
            if favoriteEvent === event {
                favoriteEventList!.events.remove(at: i)
                found = true
                break
            }
        }
        
        if !found {
            favoriteEventList!.events.append(event)
        }
        
        let data = try? JSONEncoder().encode(favoriteEventList)
        UserDefaults.standard.set(data, forKey:"favoriteEvents")
    }
}
