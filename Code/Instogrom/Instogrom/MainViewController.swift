//
//  MainViewController.swift
//  Instogrom
//
//  Created by Teddy on 2017/3/30.
//  Copyright © 2017年 Denny Tsai. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
  
    @IBAction func signOutTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
    }
    @IBAction func addPhotoTapped(_ sender: Any) {
        
        let picker = UIImagePickerController() // build up an instance of UIImagePickerController
        picker.delegate = self          // self ViewController is the delegate class
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){ //判斷有照相機功能 再規劃按鈕
            let cameraAction = UIAlertAction(title: "拍照", style: .default){ action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }
            actionSheet.addAction(cameraAction) //加入照相機按鈕
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){  //判斷有照片圖庫 再規劃按鈕
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
}
