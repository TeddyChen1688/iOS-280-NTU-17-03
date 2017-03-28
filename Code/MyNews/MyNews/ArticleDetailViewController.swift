//
//  ArticleDetailViewController.swift
//  MyNews
//
//  Created by Teddy on 2017/3/24.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    var article: Article!
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = article.heading
        contentLabel.text = article.content
        titleBar.title = article.heading
        
        dateFormatter.dateFormat = "y-MM-dd HH:mm"
        publishedDateLabel.text = dateFormatter.string(from: article.publishedDate)
        
        
        downloadArticleImage()
    }

    
    func downloadArticleImage(){
        if let imageURL = article.imageURL {
            let session = URLSession.shared
            let task = session.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("圖檔下載失敗: \(error)")
                    return
                }
                let data = data!
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            task.resume()
        }
    }
}
