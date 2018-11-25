//
//  ArtistsCollectionViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/24.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit
import SwiftSpinner
import Kingfisher

private let reuseIdentifier = "ArtistDetailCell"

class ArtistsCollectionViewController: UICollectionViewController {
    var artists = [String: Artist]()
    var imageURLs = [String: [URL]]()
    let margin = CGFloat(integerLiteral: 50)
    var heights = [String: Int]()
    var artistInfoLoaded = false
    var artistImageURLsLoaded = false

    private func calculateHeights() {
        var y = 50
        let nameHeight = 40
        let labelHeight = 25
        let tbc = tabBarController as! DetailTBController
        for artistName in tbc.event!.artistNames {
            if let artist = self.artists[artistName] {
                if artist.name != "N/A" {
                    y += labelHeight
                    y += nameHeight
                }
                if artist.followers != "N/A" {
                
                y += labelHeight
                
                y += nameHeight
            }
            if artist.popularity != -1 {
                
                y += labelHeight
                
                y += nameHeight
            }
                if artist.url != URL(string: "N/A") {
                
                    y += labelHeight
                
                    y += nameHeight
                }
            }
            let imageHeight = 300
            let imageMargin = 20
            if let imageURLs = imageURLs[artistName] {
                for _ in imageURLs {
                    y += imageHeight + imageMargin
                }
            }
            self.heights[artistName] = y
            print("height here", artistName)
        }
    }
    
    private func finishFetching() {
        DispatchQueue.main.async {
            self.calculateHeights()
            self.collectionView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    private func finishLodingArtistInfo() {
        artistInfoLoaded = true
        if artistImageURLsLoaded {
            finishFetching()
        }
    }
    
    private func finishLoadingImageURLs() {
        artistImageURLsLoaded = true
        let tbc = self.tabBarController as! DetailTBController
        if tbc.event!.segment == "Music" {
            if artistInfoLoaded {
                finishFetching()
            }
        } else {
            finishFetching()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching Artist info...")

        let tbc = self.tabBarController as! DetailTBController
        
        if tbc.event.segment == "Music" {
            if tbc.event.artistNames.count < 2 {
                fetchArtists(artistNames: tbc.event.artistNames, finally: finishLodingArtistInfo)
            } else {
                fetchArtists(artistNames: Array(tbc.event.artistNames[0..<2]), finally: finishLodingArtistInfo)
            }
        }
        
        if tbc.event.artistNames.count < 2 {
            fetchImageURLs(artistNames: tbc.event.artistNames, finally: finishLoadingImageURLs)
        } else {
            fetchImageURLs(artistNames: Array(tbc.event.artistNames[0..<2]), finally: finishLoadingImageURLs)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        self.collectionView!.delegate = self
        
        


        // Do any additional setup after loading the view.
    }
    
//    private func updateEstimatedItemSize() {
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 414, height: 1200 * min( tbc.event.artistNames.count, 2))
//        }
//    }
    
    private func fetchImageURLs(artistNames: [String], finally: @escaping ()->Void) {
        var partlyFinished = false
        if artistNames.count == 1 {
            partlyFinished = true
        }
        
        for artistName in artistNames {
            WebClient.fetch(urlString: "https://ios-event-ticket-usc.appspot.com/api/images",
                        queryName: "query",
                        queryValue: artistName,
                        success: {data in
                            let decoder = JSONDecoder()
                            let urlList: UrlList
                            do {
                                urlList = try decoder.decode(UrlList.self, from: data)
                                let urls: [URL] = urlList.urls.filter { URLComponents(url: $0, resolvingAgainstBaseURL: false)!.scheme == "https" }
                                if urls.count > 8 {
                                    self.imageURLs[artistName] = Array(urls[0..<8])
                                } else {
                                    self.imageURLs[artistName] = urls
                                }
                                if partlyFinished {
                                    finally()
                                } else {
                                    partlyFinished = true
                                }
                            } catch {
                                print("Failed to decode the JSON", error)
                                // TODO: Error handling
                                if partlyFinished {
                                    finally()
                                } else {
                                    partlyFinished = true
                                }
                                
                            }
            })
        }

//        let baseUrl = URL(string: "https://ios-event-ticket-usc.appspot.com/api/images")!
//        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
//
//        components.queryItems = [URLQueryItem(name: "query", value: artistName)]
//        let url = components.url!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if error != nil {
//                // TODO: Error handling
//                print("Error: \(error!.localizedDescription) \n")
//                return
//            }
//
//            guard let data = data, let response = response as? HTTPURLResponse else {
//                print("No data or no response")
//                // TODO: Error handling
//                return
//            }
//
//            if response.statusCode == 200 {
//
//            } else {
//                // TODO: Error handling
//                print("Status code: \(response.statusCode)\n")
//            }
//        }
//        task.resume()
    }
    
    private func fetchArtist
        (artistName: String, finished: @escaping () -> Void, failed: @escaping () -> Void) {
        WebClient.fetch(urlString: "https://ios-event-ticket-usc.appspot.com/api/artist",
                        queryName: "query",
                        queryValue: artistName,
                        noData: {
                            
                            print("nodata")
                            failed()
                        },
                        not200: {_ in
                            print("not200")
                                failed()
                        },
                        failure: {_ in
                            print("failure")
                            failed()
                        },
                        success: {data in
                            let decoder = JSONDecoder()
                            let artist: Artist
                            do {
                                artist = try decoder.decode(Artist.self, from: data)
                                self.artists[artistName] = artist
                                finished()
                            } catch {
                                print("Failed to decode the JSON", error)
                                failed()
                            }
                        })
        }
//        let baseUrl = URL(string: "https://ios-event-ticket-usc.appspot.com/api/artist")!
//        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
//
//        components.queryItems = [URLQueryItem(name: "query", value: artistName)]
//
//
//        let url = components.url!
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if error != nil {
//                // TODO: Error handling
//                print("Error: \(error!.localizedDescription) \n")
//                finished()
//                return
//            }
//
//            guard let data = data, let response = response as? HTTPURLResponse else {
//                print("No data or no response")
//                // TODO: Error handling
//                finished()
//                return
//            }
//
//            if response.statusCode == 200 {
//                let decoder = JSONDecoder()
//                let artist: Artist
//                do {
//                    artist = try decoder.decode(Artist.self, from: data)
//                    self.artists[artistName] = artist
//                    finished()
//                } catch {
//                    print("Failed to decode the JSON", error)
//                    // TODO: Error handling
//                    return
//                }
//            } else {
//                // TODO: Error handling
//                print("Status code: \(response.statusCode)\n")
//                finished()
//            }
//        }
//        task.resume()
    
    // TODO: Fetching artist info for sports
    private func fetchArtists(artistNames: [String], finally: @escaping ()->Void) {
        var partlyFinished = false
        if artistNames.count == 1 {
            partlyFinished = true
        }

        for artistName in artistNames {
            self.fetchArtist(
                artistName: artistName,
                finished: {
                if partlyFinished {
                    finally()
                } else {
                    partlyFinished = true
                }
            },
                failed: {
                    DispatchQueue.main.async {
                        self.view.showToast("Could not find artist info of \(artistName)", position: .bottom, popTime: 4, dismissOnTap: false)
                    }
                    
                    if partlyFinished {
                        finally()
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let tbc = self.tabBarController as! DetailTBController
        
        return min(tbc.event.artistNames.count, 2)
    }
    
    private func generateUITextView(y: Int, height: Int, text: String) -> UITextView {
        let tv = UITextView(frame: CGRect(x: 12, y: y, width: 414, height: height))
        tv.text = text
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }
    
    private func generateImageView(url: URL) -> UIImageView {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
        return imageView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtistCollectionViewCell
        
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
    
        let tbc = self.tabBarController as! DetailTBController

        let artistName = tbc.event.artistNames[indexPath.row]
        
        var y = 0
        
        let titleTV: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 414, height: 60))
        titleTV.text = artistName
        titleTV.font = UIFont.boldSystemFont(ofSize: 20)
        titleTV.textAlignment = .center
        cell.addSubview(titleTV)
        
        y += 50
        let nameHeight = 40
        let labelHeight = 25
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
        
        let imageHeight = 300
        let imageMargin = 20
        if let imageURLs = imageURLs[artistName] {
            for imageURL in imageURLs {
                let imageView = generateImageView(url: imageURL)
                imageView.frame = CGRect(x: 12, y:y, width: 414-12*2, height: imageHeight)
                imageView.contentMode = UIView.ContentMode.scaleAspectFit
                cell.addSubview(imageView)
                y += imageHeight + imageMargin
            }
        }
        
        //self.heights[artistName] = y
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


extension ArtistsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tbc = self.tabBarController as! DetailTBController
        
        let artistName = tbc.event.artistNames[indexPath.row]
        
        print("clv")
        print(heights)
        if let height = heights[artistName] {
            return CGSize(width: 414, height: height)
        } else {
            return CGSize(width: 414, height: 1000)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return margin
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return margin
//    }
}
