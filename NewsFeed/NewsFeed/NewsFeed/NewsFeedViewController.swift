//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Mariam Abdelhamid on 6/9/22.
//

import UIKit
import RxSwift
import CoreData

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var newsCollection: UICollectionView!
    
    var disposeBag = DisposeBag()
    var viewModel = NewsFeedViewModel()
    let cellId = "cellId"
    let HeaderId = "headerId"
    static let gategoryHeaderId = "gategoryId"
    var stockData: [String: String] = ["": ""]
    var articles: [Article] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        newsCollection.register(Header.self, forSupplementaryViewOfKind: NewsFeedViewController.gategoryHeaderId, withReuseIdentifier: HeaderId)
        
        setupCollecionLayout()

        if Reachability.isConnectedToNetwork(){
      
        viewModel.currentStock.subscribe { item in
            self.stockData[item.keys[item.startIndex]] = item.values[item.startIndex]
            self.stockData.removeValue(forKey: "")
            self.newsCollection.reloadData()
        } onError: { error in
            print(error)
        } .disposed(by: disposeBag)
        
        viewModel.articles.subscribe { item in
            
            self.articles = item
            self.newsCollection.reloadData()
            self.saveLatestTenNews(article: self.articles)
            
        } onError: { error in
            print(error)
        } .disposed(by: disposeBag)
        
            print("Internet Connection Available!")
        }else{
            
            let subArticles = ArticleCoreData.shared.getAllArticlesCoreData()
            self.creatOfflineSubArticles(subArticle: subArticles)
            self.newsCollection.reloadData()
        
        }
        
    }
    
    func saveLatestTenNews(article: [Article]){
         let tenLatestNews = article.suffix(10)
        ArticleCoreData.shared.deleteAllArticlesCoreData()
        ArticleCoreData.shared.saveArticlesToCoreData(article: Array(tenLatestNews))
    }
    
    func creatOfflineSubArticles (subArticle: [ArticleCoreDataObject]){
        for subItem in subArticle {
            let article = Article(source: Source(id: "", name: ""), author: "", title: subItem.title, articleDescription: subItem.articleDescription, url: "", urlToImage: subItem.urlToImage, publishedAt: subItem.publishedAt, content: "")
            self.articles.append(article)
        }
    }
    
}
extension NewsFeedViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderId, for: indexPath) as? Header {
            header.label.font = UIFont.systemFont(ofSize: 32)
            if indexPath.section == 0 {
            header.label.text = "  Stocks"
            } else if indexPath.section == 1 {
                header.label.text = "  Latest News"
            }else if indexPath.section == 2 {
                header.label.text = "  More News"
            }
            return header
            
        } else {
           return UICollectionReusableView()
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (stockData.count - 1)
            
        } else if section == 1 {
            if articles.count > 6 {
                return 6
            }else{
               return articles.count
            }
            
        } else {
            if articles.count > 6 {
                return articles.count - 6
            } else{
                return 0
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if indexPath.section == 0 {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StocksCell", for: indexPath) as? StocksCell {
               
                cell.setCell(stock: [Array(stockData)[indexPath.row].key:Array(stockData)[indexPath.row].value] )
                return cell }
            else {
                return UICollectionViewCell()
            }
        } else  if indexPath.section == 1 {
           
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestNewsCell", for: indexPath) as? LatestNewsCell {
                cell.setCell(article: articles[indexPath.row])
                return cell }
            else {
                return UICollectionViewCell()
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreNewsCell", for: indexPath) as? MoreNewsCell {
                if indexPath.row + 6 < articles.count{
                    cell.setCell(article: articles[indexPath.row + 6])
                    return cell
                }
            }
                 else {
                return UICollectionViewCell()
            }
            return UICollectionViewCell()
        }
    
    }

}

class Header: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}
class HeaderViewCV: UICollectionReusableView {

}
