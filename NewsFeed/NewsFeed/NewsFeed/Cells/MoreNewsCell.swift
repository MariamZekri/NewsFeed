//
//  MoreNewsCell.swift
//  NewsFeed
//
//  Created by Mariam Abdelhamid on 6/10/22.
//

import UIKit
import Kingfisher

class MoreNewsCell: UICollectionViewCell {
    
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsFullDescriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    func setCell(article :Article) {
        
        newsTitleLbl.text = article.title
        let url = URL(string: article.urlToImage)
        newsImage.kf.setImage(with: url)
        newsFullDescriptionLbl.text = article.articleDescription
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date: NSDate? = dateFormatterGet.date(from: article.publishedAt) as NSDate?
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM-dd-yyyy HH:mm"
        dateLbl.text = dateFormatterPrint.string(from: date! as Date)
    }
    
    
}
