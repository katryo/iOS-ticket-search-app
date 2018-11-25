//
//  ArtistsCollectionViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/24.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit
import SwiftSpinner

private let reuseIdentifier = "ArtistDetailCell"

class ArtistsCollectionViewController: UICollectionViewController {
    var artists = [String: Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("artistDidLoad")
        let tbc = self.tabBarController as! DetailTBController
        
        print(tbc.event.segment)
        if tbc.event.segment == "Music" {
            if tbc.event.artistNames.count < 2 {
                fetchArtists(artistNames: tbc.event.artistNames)
            } else {
                fetchArtists(artistNames: Array(tbc.event.artistNames[0..<2]))
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        self.collectionView!.delegate = self
        
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 414,height: 1200 * min( tbc.event.artistNames.count, 2))
        }

        // Do any additional setup after loading the view.
    }
    
    private func finishLoading() {
        
    }
    
    private func fetchArtist
        (artistName: String, finished: @escaping () -> Void) {
        let baseUrl = URL(string: "https://ios-event-ticket-usc.appspot.com/api/artist")!
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        
        components.queryItems = [URLQueryItem(name: "query", value: artistName)]
        
        
        let url = components.url!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print(url)
            if error != nil {
                // TODO: Error handling
                print("Error: \(error!.localizedDescription) \n")
                finished()
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data or no response")
                // TODO: Error handling
                finished()
                return
            }
            
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                let artist: Artist
                do {
                    artist = try decoder.decode(Artist.self, from: data)
                    self.artists[artistName] = artist
                    finished()
                } catch {
                    print("Failed to decode the JSON", error)
                    // TODO: Error handling
                    return
                }
            } else {
                // TODO: Error handling
                print("Status code: \(response.statusCode)\n")
                finished()
            }
        }
        task.resume()
    }
    
    private func fetchArtists(artistNames: [String]) {
        SwiftSpinner.show("Fetching Artist info...")
        var partlyFinished = false
        if artistNames.count == 1 {
            partlyFinished = true
        }

        print("fetchArtists")
        for artistName in artistNames {
            self.fetchArtist(artistName: artistName, finished: {
                if partlyFinished {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                        SwiftSpinner.hide()
                    }
                } else {
                    partlyFinished = true
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let tbc = self.tabBarController as! DetailTBController
        
        return min(tbc.event.artistNames.count, 2)
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }
    
    private func generateUITextView(y: Int, height: Int, text: String) -> UITextView {
        let tv = UITextView(frame: CGRect(x: 12, y: y, width: 414, height: height))
        tv.text = text
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtistCollectionViewCell
    
        let tbc = self.tabBarController as! DetailTBController

        let artistName = tbc.event.artistNames[indexPath.row]
        
        cell.label.text = artistName
        
        var y = 100
        let nameHeight = 60
        let labelHeight = 30
        if let artist = self.artists[artistName] {
            if artist.name != "N/A" {
                let nameLabelTV = generateUITextView(y: y, height: labelHeight, text: "Name")
                nameLabelTV.font = UIFont.boldSystemFont(ofSize: 16)
                y += labelHeight
                cell.addSubview(nameLabelTV)
                let nameTV = generateUITextView(y: y, height: nameHeight, text: artist.name)
                y += nameHeight
                cell.addSubview(nameTV)
            }
            if artist.followers != "N/A" {
                let followersLabelTV = generateUITextView(y: y, height: labelHeight, text: "Followers")
                followersLabelTV.font = UIFont.boldSystemFont(ofSize: 16)
                y += labelHeight
                cell.addSubview(followersLabelTV)
                let followersTV = generateUITextView(y: y, height: nameHeight, text: artist.followers)
                y += nameHeight
                cell.addSubview(followersTV)
            }
            if artist.popularity != -1 {
                let popularityLabelTV = generateUITextView(y: y, height: labelHeight, text: "Popularity")
                popularityLabelTV.font = UIFont.boldSystemFont(ofSize: 16)
                y += labelHeight
                cell.addSubview(popularityLabelTV)
                let popularityTV = generateUITextView(y: y, height: nameHeight, text: String(artist.popularity))
                y += nameHeight
                cell.addSubview(popularityTV)
            }
            if artist.url != URL(string: "N/A") {
                let urlLabelTV = generateUITextView(y: y, height: labelHeight, text: "Check At")
                urlLabelTV.font = UIFont.boldSystemFont(ofSize: 16)
                y += labelHeight
                cell.addSubview(urlLabelTV)

                let urlButton = UIButton()
                urlButton.frame = CGRect(x: 16, y: y, width: 200, height: nameHeight)
                urlButton.setTitle("Spotify", for: .normal)
                urlButton.setTitleColor(.blue, for: .normal)
                urlButton.addTarget(self, action: #selector(urlButtonClicked), for: .touchDown)
                urlButton.contentHorizontalAlignment = .left
                urlButton.backgroundColor = .white
                
                urlButton.tag = indexPath.row
                y += nameHeight
                cell.addSubview(urlButton)
            }
            
        }
        
        
        return cell
    }
    
    @objc func urlButtonClicked(_ sender: UIButton) {
        let tbc = self.tabBarController as! DetailTBController
        UIApplication.shared.open(artists[tbc.event.artistNames[sender.tag]]!.url)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
