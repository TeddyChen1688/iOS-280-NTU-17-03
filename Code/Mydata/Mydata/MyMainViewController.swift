//
//  MyMainViewController.swift
//  Mydata
//
//  Created by Teddy on 2017/3/27.
//  Copyright © 2017年 Teddy. All rights reserved.
//

import UIKit

class MyMainViewController: UIViewController {

    let myLocationManager = MyLocationManager()
    var result = [DataTransfer]()
    
    @IBOutlet weak var distanceSlider: UISlider!
    //    @IBOutlet weak var distanceChangedLabel: UILabel!
    //    @IBOutlet weak var storeNameLabel: UILabel!
    //    @IBOutlet weak var phoneNoLabel: UILabel!
    //    @IBOutlet weak var ratingLabel: UILabel!
    //    @IBOutlet weak var storeDistanceLabel: UILabel!
    //    @IBOutlet weak var walkingTimeLabel: UILabel!
    //    @IBOutlet weak var addressLabel: UILabel!
    @IBAction func searchTapped(_ sender: Any) {
        downLoadRestaurant(distanceSlider)
    }

    func downLoadRestaurant(_: distanceSlider){
        DataTransfer.downLoadRestaurant(with: distanceSlider, completionHandler: ([DataTransfer]?, Error?) -> Void){
            if let error = error {
                print("下載失敗: \(error)")
                return
            }
            if let result = result {
                self.result = result
            }
        }
    }
}

