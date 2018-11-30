//
//  ContainerViewController.swift
//  EventTicket
//
//  Created by RYOKATO on 2018/11/29.
//  Copyright © 2018 Denkinovel. All rights reserved.
//

import UIKit
import SwiftSpinner

private let reuseIdentifier = "InnerArtistCell"


class ArtistContainerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var artists = [String: Artist]()
    var imageURLs = [String: [URL]]()
    let margin = CGFloat(integerLiteral: 50)
    var heights = [String: Int]()
    var artistInfoLoaded = false
    var artistImageURLsLoaded = false
    
    var artistsVC: InnerArtistViewController?

    
    private func calculateHeights() {
        let nameHeight = 40
        let labelHeight = 25
        let tbc = tabBarController as! DetailTBController
        let artistNames: [String]
        if tbc.event.artistNames.count < 2 {
            artistNames = tbc.event.artistNames
        } else {
            artistNames = Array(tbc.event.artistNames[0..<2])
        }
        for artistName in artistNames {
            var y = 0
            if let artist = self.artists[artistName] {
                if artistNames[0] != artistName {
                    y += 50
                }
                if artist.name != "N/A" && artistNames[0] != artistName  {
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
            y += 400
            self.heights[artistName] = y

        }
    }
    
    private func finishFetching() {
        DispatchQueue.main.async {
            self.calculateHeights()
            self.artistsVC!.collectionView.reloadData()
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
    
    func showCurrentView(){
        if let vc = artistsVC {
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            self.containerView.addSubview(vc.view)
            //self.currentVC!.viewWillAppear(false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tbc = self.tabBarController as! DetailTBController
        if tbc.event.artistNames.count > 1 {
            if let height = self.heights[tbc.event.artistNames[0]] {
                if scrollView.contentOffset.y > CGFloat(height + 80) {
                    artistNameLabel.text = tbc.event.artistNames[1]
                }
                if scrollView.contentOffset.y < CGFloat(height + 80) {
                    artistNameLabel.text = tbc.event.artistNames[0]
                }
            }
            print(heights)
                        print(self.artistsVC!.collectionViewLayout.collectionViewContentSize.height)
                        print(self.artistsVC!.collectionView.contentSize)
                        print(self.artistsVC?.collectionView.contentInset)
                        print("height")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artistsVC = storyboard!.instantiateViewController(withIdentifier: "InnerArtistsVC") as! InnerArtistViewController
        showCurrentView()
        SwiftSpinner.show("Fetching Artist info...")
        artistsVC!.collectionView.delegate = self
        artistsVC!.collectionView.dataSource = self
        
        let tbc = self.tabBarController as! DetailTBController
        if tbc.event.artistNames.count > 0 {
            self.artistNameLabel.text = tbc.event.artistNames[0]
        }

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
                            not200: {_ in
                                if partlyFinished {
                                    finally()
                                } else {
                                    partlyFinished = true
                                }
            },
                            failure: {_ in
                                if partlyFinished {
                                    finally()
                                } else {
                                    partlyFinished = true
                                }
            },
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
                        self.view.showToast("Could not find detailed artist info of \(artistName)", position: .bottom, popTime: 4, dismissOnTap: false)
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArtistCollectionViewCell
        
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        let tbc = self.tabBarController as! DetailTBController
        
        let artistName = tbc.event.artistNames[indexPath.row]
        
        var y = 0
        
        if indexPath.row == 1 {
            let titleTV: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 414, height: 60))
            titleTV.text = artistName
            titleTV.font = UIFont.boldSystemFont(ofSize: 20)
            titleTV.textAlignment = .center
            cell.addSubview(titleTV)
            y += 50
        }
        
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
    
    
}

extension ArtistContainerViewController: UICollectionViewDelegateFlowLayout {
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
    
}
