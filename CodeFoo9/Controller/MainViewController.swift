//
//  ViewController.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/8/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //IBOulets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var changeSectionView: UIView!
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var videoStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        setUpView(colors: [#colorLiteral(red: 0.7411764706, green: 0.09019607843, blue: 0.1137254902, alpha: 1), #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)])
    }
    
    fileprivate func setUpView(colors: [UIColor]) {
        articleLabel.textColor = colors.first
        articleImageView.image = articleImageView.image?.withRenderingMode(.alwaysTemplate)
        articleImageView.tintColor = colors.first
        
        videoLabel.textColor = colors.last
        videoImageView.image = videoImageView.image?.withRenderingMode(.alwaysTemplate)
        videoImageView.tintColor = colors.last
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        (indexPath.item == 0) ? (cell.isVideo = false) : (cell.isVideo = true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.equalTo(CGPoint(x: 0, y: 0)) {
            setUpView(colors: [#colorLiteral(red: 0.7411764706, green: 0.09019607843, blue: 0.1137254902, alpha: 1), #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)])
        }
        else if scrollView.contentOffset.equalTo(CGPoint(x: view.frame.width, y: 0)) {
            setUpView(colors: [#colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1), #colorLiteral(red: 0.7411764706, green: 0.09019607843, blue: 0.1137254902, alpha: 1)])
        }

        let xPosition = scrollView.contentOffset.x / 2
            + (leftStackView.frame.width - videoStackView.frame.width) / 2 - 8
        
        changeSectionView.frame = CGRect(x: xPosition, y: changeSectionView.frame.origin.y, width: self.changeSectionView.frame.width, height: self.changeSectionView.frame.height)
    }
    
}

