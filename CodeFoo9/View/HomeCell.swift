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
    var startIndex = -10
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "SwipeLabelCell", bundle: nil), forCellWithReuseIdentifier: cellXibId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchData()
    }
    
    func fetchData() {
        startIndex = startIndex + 10
        Service.shared.fetchTheData(startIndex: startIndex) { (data, error) in
            if let error = error {
                print("Failed to fetch data ", error)
                return
            } else {
                //if self.isVideo {
                    data.forEach({ (results) in
                        if results.contentType == "video" {
                            self.videoResults.append(results)
                        }
                        
                        if results.contentType == "article" {
                            self.articleResults.append(results)
                        }
                    })
                    self.videoResults.forEach({self.ids.append($0.contentId)})
                //} else {
//                    data.forEach({ (results) in
//                        if results.contentType == "article" {
//                            self.articleResults.append(results)
//                        }
//                    })
                    self.articleResults.forEach({self.ids.append($0.contentId)})
                //}
                
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
        isVideo ? (cell.data = videoResults[indexPath.row - 1]) : (cell.data = articleResults[indexPath.row - 1])
        group.notify(queue: .main) {
            cell.comment = self.commentResults[indexPath.row - 1]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (articleResults.count != 20 && videoResults.count != 20) {
            if (indexPath.row + 1 == articleResults.count) {
                fetchData()
                //print(articleResults.count, videoResults.count)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        let webViewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        if isVideo {
            let year = getDate(data: videoResults, index: indexPath.row - 1).year
            let month = getDate(data: videoResults, index: indexPath.row - 1).month
            let day = getDate(data: videoResults, index: indexPath.row - 1).day
            webViewVC.urlString = "https://www.ign.com/videos/\(year)/\(month)/\(day)/\(videoResults[indexPath.row - 1].metadata.slug)"
            print(webViewVC.urlString)
        } else {
            let year = getDate(data: articleResults, index: indexPath.row - 1).year
            let month = getDate(data: articleResults, index: indexPath.row - 1).month
            let day = getDate(data: articleResults, index: indexPath.row - 1).day
            webViewVC.urlString = "https://www.ign.com/articles/\(year)/\(month)/\(day)/\(articleResults[indexPath.row - 1].metadata.slug)"
            print(webViewVC.urlString)
        }
        //mainController.navigationController?.pushViewController(webViewVC, animated: true)
//        UIApplication.shared.keyWindow?.rootViewController?.navigationController?.pushViewController(webViewVC, animated: true)
        UIApplication.shared.keyWindow?.rootViewController?.present(webViewVC, animated: true, completion: nil)
        //print(articleResults[indexPath.row - 1].metadata.slug)
    }
    
    func getDate(data: [DataResults], index: Int) -> (year: String, month: String, day: String) {
        let calendar = Calendar.current
        let publishDate = data[index].metadata.publishDate.formatStringToDate()
        
        let year = String(calendar.component(.year, from: publishDate))
        var month = String(calendar.component(.month, from: publishDate))
        if Int(month) ?? 0 < 10 {
            month = "0" + String(calendar.component(.month, from: publishDate))
        }
        
        var day = String(calendar.component(.day, from: publishDate))
        if Int(day) ?? 0 < 10 {
            day = "0" + String(calendar.component(.day, from: publishDate))
        }
        return (year, month, day)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: self.frame.width, height: 40)
        } else {
            return CGSize(width: self.frame.width, height: 460)
        }
    }
}
