//
//  DataTransfer.swift
//  Mydata
//
//  Created by 呂 宜倩 on 2017/3/27.
//  Copyright © 2017年 Teddy. All rights reserved.
//

import UIKit

class DataTransfer {
    let address : String
    let name : String
    let phone : String
    let rating : Double
    let imageURL : URL?
    var latitude : Double
    var longitude : Double
    var url : URL
    var distanceSlider: UISlider!
    
    init(rawData: [String: Any]){
        address = rawData["address"] as! String
        name = rawData["name"] as! String
        phone = rawData["phone"] as! String
        rating = rawData["rating"] as! Double

        if let imageURLString = rawData["photo"] as? String{
            imageURL = URL(string: imageURLString)
        }
        else{
            imageURL = nil
        }
      
        let myLocationManager = MyLocationManager()
        myLocationManager.requestLocation(completionHandler: { location in
        print("from viewController\(location)")

        self.longitude = rawData["location.coordinate.longitude"] as! Double
        self.latitude = rawData["location.coordinate.latitude"] as! Double
        
        let distance = self.distanceSlider.value
        
        let url = URL (string: "https://food-locator-dot-hpd-io.appspot.com/v1/location_query?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&distance=\(distance)")!
        self.url = url
        })
    }
    
    class func downLoadRestaurant(with: distanceSlider, completionHandler: @escaping ([DataTransfer]?, Error?) -> Void){
        let session = URLSession.shared
        let url  = self.url
        let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            if let error = error {
                print("API 下載錯誤:\(error)")
                return
            }
            let data = data!
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let results = jsonObject as?  [[String: Any]] {
                if results.count == 0 {
                    print("找不到附近的餐廳")
                    return
                }
                //let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                //let result = results[randomIndex]
                let result = results.map{ DataTransfer(rawData: $0)}
                print("資料下載完成 \(result)")
                completionHandler(result, nil)
            }// End of JSON Data --> JSON Object
        })  // End of datatask closure from URL下載網路數據完畢選定餐廳
        task.resume()   // 開始執行 datatask,下載網路數據
    }
}


