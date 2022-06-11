//
//  NewsFeedViewModel.swift
//  NewsFeed
//
//  Created by Mariam Abdelhamid on 6/9/22.
//

import Foundation
import RxSwift

class NewsFeedViewModel {
    
    
    private var timer = Timer()
    private var stocksArray: [String] = []
    var currentStock: BehaviorSubject<[String : String]> = BehaviorSubject(value: ["" : ""])
    var articles: BehaviorSubject<[Article]> = BehaviorSubject(value: [])
    var helperService = NetworkService()

    
    init() {
        stocksArray = getCSVData()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1 , repeats: true, block: { _ in
            self.updateCurrentStock()
        })
        
        articles.onNext(helperService.loadJson(filename: "Cnn") ?? [])
        
    }
    
    
    
    private func updateCurrentStock() {
        
        if let item = stocksArray.randomElement() {
            
            let stockDic = item.components(
                separatedBy: ","
            )
            
            if stockDic.count > 1 {
                currentStock.onNext([stockDic[0] : stockDic[1]])
                
            }
            
        }
        
    }
    
    
    private func getCSVData() -> [String] {
        do {
            let path = Bundle.main.path(forResource: "Stocks", ofType: "csv") ?? ""
            
            let content = try String(contentsOfFile: path)
            let parsedCSV = content.components(
                separatedBy: "\n"
            )
            return parsedCSV
            
        }
        catch {
            return []
        }
    }
    
}

