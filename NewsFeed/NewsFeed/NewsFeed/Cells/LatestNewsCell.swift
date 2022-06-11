//
//  LatestNewsCell.swift
//  NewsFeed
//
//  Created by Mariam Abdelhamid on 6/10/22.
//

import UIKit
import Kingfisher

class LatestNewsCell: UICollectionViewCell {
  
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    func setCell(article :Article) {
        
        newsTitleLbl.text = article.title
        let url = URL(string: article.urlToImage)
        newsImage.kf.setImage(with: url)
        newsImage.layer.cornerRadius = 15
       newsImage.clipsToBounds = true
    }
    
}
