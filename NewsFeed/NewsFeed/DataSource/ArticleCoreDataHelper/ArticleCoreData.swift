//  ArticleCoreData.swift
//  NewsFeed
//
//  Created by Mariam Abdelhamid on 6/10/22.
//

import UIKit
import CoreData

class ArticleCoreData {
    
    static let shared = ArticleCoreData()
    var context: NSManagedObjectContext!
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveArticlesToCoreData(article: [Article]?) {
        
        guard let entityArticle = NSEntityDescription.entity(forEntityName: "ArticlesData", in: context) else {
            return
        }
        
        guard let article = article else {
            return
        }
        
        for article in article {
            let articleItemManagedObject = NSManagedObject(entity: entityArticle, insertInto: context)
            articleItemManagedObject.setValue(article.title, forKey: "title")
            articleItemManagedObject.setValue(article.articleDescription, forKey: "articleDescription")
            articleItemManagedObject.setValue(article.urlToImage, forKey: "urlToImage")
            articleItemManagedObject.setValue(article.publishedAt, forKey: "publishedAt")
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func deleteAllArticlesCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesData")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            print("Failed")
        }
    }
    
    @discardableResult
    func getAllArticlesCoreData(printItems: Bool = false) -> [ArticleCoreDataObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticlesData")
        var articleCoreDataObjects = [ArticleCoreDataObject]()
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as? [NSManagedObject] ?? [NSManagedObject]() {
                let articleCoreDataObject = ArticleCoreDataObject()
                articleCoreDataObject.title = data.value(forKey: "title") as? String ?? ""
                articleCoreDataObject.articleDescription = data.value(forKey: "articleDescription") as? String ?? ""
                articleCoreDataObject.publishedAt = data.value(forKey: "publishedAt") as? String ?? ""
                articleCoreDataObject.urlToImage = data.value(forKey: "urlToImage") as? String ?? ""

                
                articleCoreDataObjects.append(articleCoreDataObject)

            }
            
        } catch {
            print("Failed")
        }
        return articleCoreDataObjects
    }
    
}

class ArticleCoreDataObject {
    var title: String = ""
    var articleDescription: String = ""
    var publishedAt: String = ""
    var urlToImage: String = ""
}
