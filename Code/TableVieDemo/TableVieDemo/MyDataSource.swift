//
//  MyDataSource.swift
//  TableVieDemo - Basics for TableView
//
//  Created by Teddy on 2017/3/20.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//  MVC : Model, Controller

import UIKit
class MyDataSource:  NSObject, UITableViewDataSource {
    
  let names = [
        "Bob",
        "Peter",
        "Amy",
        "John",
        "Eva",
        "Mike",
        "Bob",
        "Peter",
        "Amy",
        "John",
        "Eva",
        "Mike",
        "Bob",
        "Peter"
    ]
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("正在畫第 \(indexPath.row) 個")
            // 從回收場拖一個再利用 cell 出來
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let name = names[indexPath.row]
            cell.textLabel?.text = name
            return cell
    }
}
