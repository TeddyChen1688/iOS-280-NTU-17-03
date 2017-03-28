//
//  ViewController.swift
//  ViewControllerLC
//
//  Created by Teddy on 2017/3/20.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    // 要帶到第二頁的輸入文字
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // 啟動 segue 傳值功能
        if segue.identifier == "showSecondPage" {// 確認要執行的目標物 segue, 注意這不像 Label 靠拖拉元件來指派
            
            let nextVC = segue.destination as! secondViewController // 已經指定 segue.destination 存在故直接轉態
            nextVC.stringFromFirstVC = textField.text // 指定下一頁的Class(SecondViewController)屬性為本頁的某字串
            // UI 元件 button 並沒有出現在程式碼裡面
            
        print("\(segue.destination)")
        }
    }
    
}

