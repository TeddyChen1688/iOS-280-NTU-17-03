//
//  secondViewController.swift
//  ViewControllerLC
//
//  Created by Teddy on 2017/3/20.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {

    var stringFromFirstVC : String?
    
    @IBOutlet weak var textLabel: UILabel! // 接來自第一頁的字串
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = stringFromFirstVC // 經由 prepare (for:sender) 已經載入到 segue 的變數stringFromFirstVC(它是在本頁所定義的, segue 也認識)
    }
   
}
