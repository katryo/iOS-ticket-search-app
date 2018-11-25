//
//  DetailTBController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/23.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit

class DetailTBController: UITabBarController, UITabBarControllerDelegate {
    var event: Event!
    
    func updateButtons() {
        let nc = navigationController as! RootNavigationController
        let favoriteButton: UIBarButtonItem
        if nc.hasFavorited(event: event!) {
            favoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-filled"), style: .plain, target: self, action: #selector(unfavClicked))
        } else {
            favoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite-empty"), style: .plain, target: self, action: #selector(favClicked))
        }
        
        let twitterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "twitter"), style: .plain, target: self, action: #selector(twitterClicked))
        navigationItem.rightBarButtonItems = [favoriteButton, twitterButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButtons()
        self.delegate = self
        
        
        let venueVC = viewControllers?[2] as! VenueViewController
        WebClient.fetch(urlString: "https://ios-event-ticket-usc.appspot.com/api/venue",
                        queryName: "id",
                        queryValue: event!.id,
                        success: venueVC.decodeVenue)
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController === viewControllers![1] {
//            print("artist")
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateButtons()
    }

    
    @objc
    func twitterClicked() {
        var components = URLComponents(string: "https://twitter.com/intent/tweet")
        let text = "Check out \(event.artistNames.joined(separator: " | ")) at \(event.venueName). Website: \(event.url)"
        components!.queryItems = [URLQueryItem(name: "text", value: text)]
        UIApplication.shared.open(components!.url!)
    }
    
    @objc
    func unfavClicked() {
        let nc = navigationController as! RootNavigationController
        nc.removeFavorite(event: event)
        viewDidAppear(false)
    }
    
    @objc
    func favClicked() {
        let nc = navigationController as! RootNavigationController
        nc.updateFavorites(event: event)
        viewDidAppear(false)

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
