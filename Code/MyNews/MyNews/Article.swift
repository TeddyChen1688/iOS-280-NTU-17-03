//
//  Article.swift
//  MyNews
//
//  Created by Teddy on 2017/3/20.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//
import UIKit

let ArticlesURL = URL(string: "https://hpd-iosdev.firebaseio.com/news/latest.json")!

class Article {  // 把 App 用到的資料包裝成查表(Model Class), No Acion, No NSObject 繼承

    let heading: String? // 自由電子報可能沒有標題
    let content: String?    // 自由電子報可能沒有
    let imageURL: URL?
    let catagory: String?// 自由電子報可能沒有
    let publishedDate: Date // TimeStamp, 系統給的一定有 -->  轉成格式
    let url: URL // 一定有轉成
    
    init(rawData: [String: Any]) { // initializer: like constructor 給初始值給先前宣告的數
        
        heading = rawData["heading"] as? String
        content = rawData["content"] as? String
        
        if let imageURLString = rawData["imageUrl"] as? String{
            imageURL = URL(string: imageURLString)
        }
        else {
            imageURL = nil
        }
        
        catagory = rawData["catagory"] as? String
        
        let publishedDateMS = rawData["publishedDate"] as! Double
        publishedDate = Date(timeIntervalSince1970: publishedDateMS / 1000)
        // print("\(publishedDate)")
        // 2017-03-26 06:42:00 +0000
       
        let urlString = rawData["url"] as! String
        url = URL(string: urlString)!
    }
    
    class func downLoadLatestArticles(completionHandler: @escaping ([Article]?, Error?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: ArticlesURL) { (data, response, error) in
            
            if let error = error { // Early Return
                print("下載新聞錯誤\(error)")
                completionHandler(nil, error)
                return
            }
            let data = data!
            
            if let jsonObjects = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let articlesArray = jsonObjects as? [[String : Any]]{
                // type casting
                
            // 1   var articles = [Article]() // 做一個空的 Array, article is a local variable
            // 2  for articleDict in articlesArray{
            // 3       let article = Article(rawData: articleDict)
            // 4      articles.append(article)
            // 5   }
                let articles = articlesArray.map { Article(rawData: $0)} // Array Data 迅速換算
                print("新聞下載完成!!")
                completionHandler(articles, nil)
            } // End of jsonObject
        } // End of task
        task.resume()
    }
}
