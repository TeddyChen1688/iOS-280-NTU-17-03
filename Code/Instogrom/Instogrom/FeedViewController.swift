//  FeedViewController.swift
//  Instogrom
//
//  Created by Teddy on 2017/3/30.
//  Copyright © 2017年 Denny Tsai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseDatabaseUI
import SDWebImage
import SVProgressHUD

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: FIRDatabaseReference!  // see example in Firebase
    var postsRef: FIRDatabaseReference!  // see example in Firebase
    
    var dataSource: FUITableViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ref = FIRDatabase.database().reference() // 取得 Firebase 的根目錄
        postsRef = ref.child("posts") // 取得 Firebase 的根目錄 --> posts 目錄
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
       
        let query = postsRef.queryOrdered(byChild: "postDateReversed")
        
        dataSource = tableView.bind(to: query) { tableView, indexPath, snapshot -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            
            if let postData = snapshot.value as? [String: Any] {
                cell.emailLabel.text = postData["email"] as? String
                
                let imageURLString = postData["imageURL"] as! String
                let imagURL = URL(string: imageURLString)!
                cell.photoImageView.sd_setImage(with: imagURL)
            }
            return cell
        }
    }
//        ref.updateChildValues(["13":"abc"])

//        // 意欲當有資料變動則通報 by value change 全部重傳一次 大耗流量
//        ref.observe(.value, with: { snapshot in   // with 後面拿傳回的產物
//                if let value = snapshot.value as? [String: Any] {
//                    debugPrint(value)
//                }
        // 意欲當有資料變動則通報 by childAdded,  change 只傳新增的(刪除時不作用)
   
//       ref.observe(.childAdded, with: { snapshot in
//            if let value = snapshot.value as? [String: Any] {
//                debugPrint(value)
//                debugPrint(snapshot)
//            }
//      ref.observe(.childChanged, with: { snapshot in
//        ref.observe(.childRemoved, with: { snapshot in
//            if let value = snapshot.value as? [String: Any] {
//                debugPrint(value)
//                debugPrint(snapshot)
//            }
//        })

    //選擇照相機按鈕 --> 可以選圖庫或者是照相
    @IBAction func takePhotoTapped(_ sender: Any) {
        let picker = UIImagePickerController() // build up an instance of UIImagePickerController
        picker.delegate = self          // self ViewController is the delegate class
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //判斷有照相機功能 再規劃按鈕
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "拍照", style: .default){ action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
             actionSheet.addAction(cameraAction) //加入照相機按鈕
        }
        //判斷有照片圖庫 再規劃按鈕
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let libraryAction = UIAlertAction(title: "選照片", style: .default){ action in
                picker.sourceType = .photoLibrary // 照片用選的
                self.present(picker, animated: true, completion: nil)
            }
            actionSheet.addAction(libraryAction)    //加入圖庫按鈕
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        actionSheet.addAction(cancelAction) //加入 cancell 按鈕
        present(actionSheet, animated: true, completion: nil)// 秀圖 actionSheet 3 按鈕
    }

    // 相對於照相按鈕 這是登出按鈕
    func signOutTapped(_ sender: Any) {
         try! FIRAuth.auth()?.signOut()
    }
    //取得了相片 UIImage 檔案, 上傳到 FireBase Storage 存起來
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage // 取得UIImage
    let postRef = postsRef.childByAutoId() // FIRDatabaseReference
    let postKey = postRef.key
        
        if FIRAuth.auth()?.currentUser == nil {
            print("No peroson")
            return
        }
        
    let currentUser = (FIRAuth.auth()?.currentUser)!

    var postData: [String: Any] = [
        "authorUID": currentUser.uid,
        "email": currentUser.email!,
        "imagePath":"",
        "imageURL":"",
        "postDate": 0,
        "postDateReversed": 0,
        ]
        
        
    if let imageData = UIImageJPEGRepresentation(image, 0.7){ //轉成  NSData, imageData is an optional
        let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
                
        let imageRef = FIRStorage.storage().reference().child("photos/\(postKey).jpg") //get content type
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.showProgress(0, status: "檔案上傳中")
    
        
        let uploadTask = imageRef.put(imageData, metadata: metadata) { metadata, error in      // upload
            SVProgressHUD.dismiss()
            guard let metadata = metadata else {
                    print("檔案上傳失敗")
                    return
                }
            print("上傳完成了")
            
            postData["imagePath"] = imageRef.fullPath
            postData["imageURL"] = metadata.downloadURL()!.absoluteString // 需轉成 String
            
            let now = Date ()
            let postDate = Int(round(now.timeIntervalSince1970 * 1000))
            postData["postDate"] = postDate
            postData["postDateReversed"] = -postDate

            debugPrint(postData)
            postRef.updateChildValues(postData)
//            debugPrint(metadata)
//            print(metadata.downloadURL()!)
        }
        
        uploadTask.observe(.progress, handler: { (snaphot) in
            guard let progress = snaphot.progress else {
            return
            }
            SVProgressHUD.showProgress(Float(progress.fractionCompleted))
            print("\(progress.fractionCompleted)") //上傳進
        })
    }
   
    dismiss(animated: true, completion: nil)
    
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
//        return cell
     }
 }
