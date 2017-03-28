//
//  ViewController.swift
//  PlusOneCounterio.hpd.iosdev.ios280
//
//  Created by Teddy on 2017/3/2.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//
import UIKit
class ViewController: UIViewController {
    var count = 0
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func plusOneTapped(_ sender: Any) {
        
        // Actions when press +1
        count = count + 1
        countLabel.text = "\(count)"
    }
    @IBAction func ResetButton(_ sender: Any) {
        // Actions when press Reset
        count = 0
        countLabel.text = "\(count)"
    }
   @IBAction func minusOneTapped(_ sender: Any) {
        count = count-1
        countLabel.text = "\(count)"
}
   @IBAction func doubleTapped(_ sender: Any) {
    count = count * 2
   countLabel.text = "\(count)"
}
    
    @IBOutlet weak var plusNtextfield: UITextField!
    
    @IBAction func plusNTapped(_ sender: Any) {
        
        if let plusNfieldString = plusNtextfield.text, let plusNfieldInt = Int(plusNfieldString){
            count = count + plusNfieldInt
            countLabel.text = "\(count)"
        }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

