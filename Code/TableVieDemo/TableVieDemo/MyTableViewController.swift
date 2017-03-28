//
//  MyTableViewController.swift
//  TableVieDemo
//
//  Created by Teddy on 2017/3/20.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//
//  MVC : View Controller

import UIKit

class MyTableViewController: UITableViewController {
    
    let datasource = MyDataSource() //  實作一個物件, 成為一個屬性, 一直存在.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = datasource
    }
  }
