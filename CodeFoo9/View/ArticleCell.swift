//
//  ArticleCell.swift
//  CodeFoo9
//
//  Created by hor kimleng on 3/8/19.
//  Copyright © 2019 hor kimleng. All rights reserved.
//

import UIKit
import AlamofireImage

class ArticleCell: UICollectionViewCell {

    //IBOutlets
    @IBOutlet weak var postedDurationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    var data: DataResults! {
        didSet {
            if data.metadata.title == nil {
                titleLabel.text = data.metadata.headline
            } else {
                titleLabel.text = data.metadata.title
            }
            descriptionLabel.text = data.metadata.description
            postedDurationLabel.text = data.metadata.publishDate.formatStringToDate().durationAgo()
            guard let url = URL(string: data.thumbnails[0].url) else { return }
            thumbnailImageView.af_setImage(withURL: url)
        }
    }
    
    var comment: Content! {
        didSet {
            commentButton.setTitle(" Comment: \(comment.count)", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 15
    }
}
