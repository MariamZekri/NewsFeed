//
//  StocksCell.swift
//  NewsFeed
//
//  Created by Mariam Abdelhamid on 6/10/22.
//

import UIKit

class StocksCell: UICollectionViewCell {
    
    @IBOutlet weak var currencyNameLbl: UILabel!
    
    @IBOutlet weak var currencyValueLbl: UILabel!
    
    func setCell(stock :[String : String]) {
        
        currencyNameLbl.text = stock.keys[stock.startIndex].replacingOccurrences(of: "\"", with: "")
        let currenecyValueFloat = Float(stock.values[stock.startIndex].trimmingCharacters(in: .whitespacesAndNewlines))
        
        if currenecyValueFloat ?? 0.00 > 0 {
            currencyValueLbl.textColor = .systemGreen
        }else{
            currencyValueLbl.textColor = .red
        }
        
        let currenecyValue =  String(format: "%.2f", currenecyValueFloat ?? 0.00)
        
        currencyValueLbl.text = "\(currenecyValue)  USD"
    }
}
