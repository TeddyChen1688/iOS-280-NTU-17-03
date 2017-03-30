//
//  signInViewController.swift
//  Instogrom
//
//  Created by Teddy on 2017/3/29.
//  Copyright © 2017年 Denny Tsai. All rights reserved.
//

import UIKit
import Firebase

class signInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("使用者已經登入: \(FIRAuth.auth()?.currentUser)")
        try! FIRAuth.auth()?.signOut()
    }
    
    
    @IBAction func signInTapped(_ sender: Any) {
        
        print("開始登錄了")
        
        guard let email = emailField.text, let password = passwordField.text else {
            print ("Email 或密碼登入錯誤")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            guard let user = user else { //FIRuser
                print("登入失敗!! \(error)")
                return
            }
        print (" 使用者 \(user.email) 登入成功")
        }
    }
    @IBAction func signOutTapped(_ sender: Any) {
        
        try! FIRAuth.auth()?.signOut()
        
    }

}
