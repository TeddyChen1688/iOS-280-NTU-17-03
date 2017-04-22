//
//  ViewController.swift
//  wheretoLunch
//
//  Created by Teddy on 2017/3/6.
//  Copyright © 2017年 Teddy Chen. All rights reserved.
//
import UIKit
import MapKit

class ViewController: UIViewController {
    // 1.製作 UI 物件
    let myLocationManager = MyLocationManager()
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceChangedLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var storeDistanceLabel: UILabel!
    @IBOutlet weak var walkingTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func distanceChanged(_ sender: Any) {
        let distance = round(distanceSlider.value * 10) / 10
        distanceChangedLabel.text = "\(distance) km"
    }
    @IBAction func searchTapped(_ sender: Any) {
        // 2.呼叫 subClass 取得定位資料存入 location
        myLocationManager.requestLocation(completionHandler: { location in
            print("from viewController\(location)") // location is a [CLLocation] 定義於 subclass
            
            let distance = self.distanceSlider.value // 對 closure 裡頭執行的 reference 動作, self 指在 UIViewController 找到 distanceSlider 執行 若不加會在myLocationManager 裡頭找 distanceSlider, 結果是找不到的
            let session = URLSession.shared // URLSession 是一個資料型別, 在這裡先存 URLSession.shared 到一個參考物 (reference) session
            let url = URL (string: "https://food-locator-dot-hpd-io.appspot.com/v1/location_query?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&distance=\(distance)")!
            // location 具有 .cooridinate 屬性 再往下一階有 latitude/longitude 屬性可以取用
            print("\(url)")
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
            // 3. 從網站下載資料, 存入一個參考物 task, 資料型別是 URLSessionDataTask, 表示存放的參考物 completionHandler 指出數據包含三種東西: data, response, error.
                if let error = error {
                    print("API 下載錯誤:\(error)")
                    return
                }
                let data = data! //必定有資料 ！！
                // 4. 處理從網站下載的資料變成 Swift 可以辨識的東西
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let results = jsonObject as?  [[String: Any]] { //, let firstResult = results.first
                
                    if results.count == 0 {   //預防在深山裡找不到而 nil-> 當機,故做一個 early return
                        print("找不到附近的餐廳")
                        return
                    }
                    // 5. 隨機取一家餐廳
                    let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                    let result = results[randomIndex]
                    // 設定 MKDirectionRequest 的輸入參數:Source,destination by MKMapView 物件
                    let currentLocationPlacemark = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil) //create a placemark for source
                    let currentLocationMapItem = MKMapItem(placemark: currentLocationPlacemark) // create a MapItem for source
                    let latitude = result["latitude"] as! Double
                    let longitude = result["longitude"] as! Double
                    let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    //create a CLLocationCoordinate2D for destination
                    let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
                    //create a placemark for destination
                    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)//create a MapItem for destination
                    // 總結設定 MKDirectionRequest 的輸入參數:Source,destination,transportType
                    let request = MKDirectionsRequest()
                    request.source = currentLocationMapItem
                    request.destination = destinationMapItem
                    request.transportType = .walking
                    // 執行 MKDirection 方法, 產出 response, 內有規劃結果
                    let directions = MKDirections(request: request)
                    // 6. 取得到餐廳的距離及需要時間
                    directions.calculateETA(completionHandler: { response, error in
                        if let error = error {
                            print("路徑規劃錯誤: \(error)")
                            return
                        } // Early Return in case error
                        let response = response!
                        print("結果: \(response.expectedTravelTime / 60),\(response.distance)")
                        print("\(result)")// 第一筆解析結果 可以用 Key Value 讀出
                        // 7.1 規劃地圖上的顯示: 加一個大頭針在 map
                        let pointAnnotation = MKPointAnnotation()
                        self.mapView.removeAnnotations(self.mapView.annotations) //把先前加的點先清除
                        pointAnnotation.coordinate = destinationCoordinate
                        self.mapView.addAnnotation(pointAnnotation)     //加一個點在 map, 會一直加
                        self.mapView.showsUserLocation = true // 顯示自己位置
                        // 7.2 規劃地圖上的顯示: 規劃可以操縱縮放的地圖視窗盒
                        print("拉棒尺度：\(self.distanceSlider.value)")
                        let degree = 1.0 / 111 * self.distanceSlider.value * 2.0// 一度相當於 111 km, 規劃 目標在中心,起點必然在可見範圍
                        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(degree), longitudeDelta: CLLocationDegrees(degree))
                        let region = MKCoordinateRegion(center: destinationCoordinate, span: span)
                        self.mapView.region = region
                        // 7.3 規劃 UI 上的顯示: 距離,時間,店名,....
                        DispatchQueue.main.async {
                            self.storeDistanceLabel.text = "\(Int(response.distance)) m"
                            let walkTime = Int(response.expectedTravelTime / 60 )
                            self.walkingTimeLabel.text = "\(walkTime) min."
                        }
                    })  // end of calculateETA closure
                    //configure the Label in UIView
                    DispatchQueue.main.async {
                        self.storeNameLabel.text = result["name"] as! String
                        self.phoneNoLabel.text = result["phone"] as! String
                        self.addressLabel.text = result["address"] as! String
                        self.ratingLabel.text = "\(result["rating"] as! Double)"
                    }
                } // End of JSON Data --> JSON Object
            })  // End of datatask closure from URL下載網路數據完畢選定餐廳
            task.resume()   // 開始執行 datatask,下載網路數據
        }) // end of myLocation closure, 取得定位, 下載網路
    } // end of Action after press // 要吃什麼勒
    
    @IBAction func makePhoneCall(_ sender: Any) {
        let phoneNo = phoneNoLabel.text
        let url: NSURL = URL(string: "TEL://phoneNo")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        print("did call")
    }
}

