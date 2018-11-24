//
//  DetailTBController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class DetailTBController: UITabBarController {
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-empty"), style: .plain, target: self, action: #selector(favClicked))
        let twitterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "twitter"), style: .plain, target: self, action: #selector(twitterClicked))
        navigationItem.rightBarButtonItems = [button, twitterButton]
        print("vdl")
    }
    
    @objc
    func twitterClicked() {
        var components = URLComponents(string: "https://twitter.com/intent/tweet")
        let text = "Check out \(event.artistNames.joined(separator: " | ")) at \(event.venueName). Website: \(event.url)"
        components!.queryItems = [URLQueryItem(name: "text", value: text)]
        UIApplication.shared.open(components!.url!)
    }
    
    @objc
    func favClicked() {
        let nc = navigationController as! RootNavigationController
        nc.updateFavorites(event: event)
//        var found = false
//        for (i, favoriteEvent) in nc.favoriteEventList!.events.enumerated() {
//            if favoriteEvent === event {
//                nc.favoriteEventList!.events.remove(at: i)
//                found = true
//                break
//            }
//        }
//
//        if !found {
//            nc.favoriteEventList!.events.append(event)
//        }
//
//        let data = try? JSONEncoder().encode(nc.favoriteEventList)
//        UserDefaults.standard.set(data, forKey:"favoriteEvents")
    }
 
}
