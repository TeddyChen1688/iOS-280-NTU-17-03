//
//  MyLocationManager.swift
//  wheretoLunch
//
//  Created by Teddy Chen on 2017/3/11.
//  Copyright © 2017年 Teddy. All rights reserved.
//
import UIKit
import CoreLocation
class MyLocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var completionHandler: ((CLLocation) -> Void)?
    var isRequestingLocation = false
    // 1. 指定本身是跟 CLLocationManager 存取位置資料的主體
    override init(){
        super.init() //先執行父類的初始化 再進行客製化
        locationManager.delegate = self
  }
    //   2. 使用 requestLocation 方法存取位置資料, 結果放在 completionHandler, datatype 是 CLLocation
    func requestLocation(completionHandler: @escaping ((CLLocation) -> Void)) {
        self.completionHandler = completionHandler
        isRequestingLocation = true
        
        // 2.1 根據規則:須先獲得存取位置資料許可權
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        // 2.1 根據規則:須先指定存取位置精度
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // 2.3 執行存取位置
        locationManager.requestLocation()
    } // end of closure of requestLocation
    
        // 3. TBD for didUpdateLocation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isRequestingLocation{
            return  // Early return: 檢查執行的條件 一不滿足即刻跳出
        }
        isRequestingLocation = false
        let location = locations.first! // 何時指定 locations 的 dataType 是 [CLLocation] ?
        completionHandler?(location)
    }
    // 4. TBD for didFailError
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error) {
        print("didFailWithError")
    }
}
