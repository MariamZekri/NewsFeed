//
//  NetworkService.swift
//  NewsFeed
//
//  Created by Mariam Abdelhamid on 6/10/22.
//

import Foundation

class NetworkService{
    
    func loadJson(filename fileName: String) -> [Article]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(News.self, from: data)
                return jsonData.articles
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
