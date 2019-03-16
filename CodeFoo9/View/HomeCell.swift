//
//  HomeCell.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/11/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let cellId = "ArticleCell"
    fileprivate let cellXibId = "SwipeLabelCell"
    fileprivate var articleResults = [DataResults]()
    fileprivate var videoResults = [DataResults]()
    fileprivate var ids = [String]()
    fileprivate var idsString = ""
    fileprivate let group = DispatchGroup()
    fileprivate var commentResults = [Content]()
    var isVideo = false
    //var frameWidth = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "SwipeLabelCell", bundle: nil), forCellWithReuseIdentifier: cellXibId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        Service.shared.fetchTheData { (data, error) in
            if let error = error {
                print("Failed to fetch data ", error)
                return
            } else {
                if self.isVideo {
                    data.forEach({ (results) in
                        if results.contentType == "video" {
                            self.videoResults.append(results)
                        }
                    })
                    self.videoResults.forEach({self.ids.append($0.contentId)})
                } else {
                    data.forEach({ (results) in
                        if results.contentType == "article" {
                            self.articleResults.append(results)
                        }
                    })
                    self.articleResults.forEach({self.ids.append($0.contentId)})
                }
                
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
                
                self.fetchComment()
            }
        }
    }
    
    func fetchComment() {
        
        group.enter()
        
        self.ids.forEach { (id) in
            if idsString.isEmpty {
                idsString =  id
            } else {
                idsString = idsString + "," + id
            }
        }
        
        Service.shared.fetchTheComment(idsString: idsString) { (comments, error) in
            if let error = error {
                print("Failed to fetch comments ", error)
                return
            } else {
                self.commentResults = comments
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                self.group.leave()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isVideo {
            return videoResults.count
        } else {
            return articleResults.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellXibId, for: indexPath) as! SwipeLabelCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ArticleCell
        isVideo ? (cell.data = videoResults[indexPath.row]) : (cell.data = articleResults[indexPath.row])
        group.notify(queue: .main) {
            cell.comment = self.commentResults[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: self.frame.width, height: 40)
        } else {
            return CGSize(width: self.frame.width, height: 460)
        }
    }
}
