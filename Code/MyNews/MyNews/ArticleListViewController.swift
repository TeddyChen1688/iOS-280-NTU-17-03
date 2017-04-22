//
//  ArticleListViewController.swift
//  MyNews
//
//  Created by Teddy on 2017/3/20.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//

import UIKit

class ArticleListViewController: UITableViewController {

    var articles = [Article]() {// 資料一改動就執行的動作, 把更改資料結構和更新UI切開來
        didSet{
            DispatchQueue.main.async {  // GCD: GrandCentralDispatch 超車道
                self.tableView.reloadData() //  更新  UI
            }
        }
    }
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadLatestArticles()
    }
    // 1. 從 URL 下載, viewDidLoad() 就下載
    
    func downloadLatestArticles(){
        Article.downLoadLatestArticles { articles, error in
            if let error = error {
                print("下載失敗: \(error)")
                return
            }
            if let articles = articles {
                self.articles = articles
                self.refreshControl?.endRefreshing()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath)
        
        let article = articles[indexPath.row]

        dateFormatter.dateFormat = "y-MM-dd HH:mm"
        
        cell.textLabel?.text = article.heading
        cell.detailTextLabel?.text = dateFormatter.string(from: article.publishedDate)  // TimeStamp started from 19700101 00:00:00 in ms
        
        return cell
    }
//    @IBAction func refreshPulled(_ sender: Any) {
//        print("update")
        // downloadLatestArticles()
//    }
    
    @IBAction func refreshPulled(_ sender: Any) {
        print("updating.....")
        downloadLatestArticles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showArticleDetail" {
            print ("翻頁了")
            let cell = sender as! UITableViewCell
            
            // 實作一個 UIalertController 物件 myAlert
            let myAlert = UIAlertController(title: "Hey Pals !!", message: "This is UIAlertController.", preferredStyle: UIAlertControllerStyle.alert)
            // 規劃 "OK" 按鈕, 並沒有在 Main.storyboard 規劃 UI 元件
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (myAlert: UIAlertAction) in
                let detailVC = segue.destination as! ArticleDetailViewController
                let indexPath = self.tableView.indexPath(for: cell)!
                let article = self.articles[indexPath.row]
                detailVC.article = article
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            // 規劃 "Cancel" 按鈕
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action:UIAlertAction) -> () in
                print("Cancelled")
                self.dismiss(animated: true, completion: nil)
            })
            //把第一顆按鈕加到警告控制器
            myAlert.addAction(okAction)
            print("2nd point")
            //把第二顆按鈕加到警告控制器
            myAlert.addAction(cancelAction)
            print("3rd point")
            // 印出 UIAlert 視窗
            self.present(myAlert, animated: true, completion: nil)
        }
    
    }
    
}
