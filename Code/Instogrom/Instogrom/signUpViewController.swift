//
//  signUpViewController.swift
//  Instogrom
//
//  Created by Teddy on 2017/3/30.
//  Copyright © 2017年 Denny Tsai. All rights reserved.
//

import UIKit
import Firebase

class signUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBAction func signUpTapped(_ sender: Any) {
        
        print("註冊了")
        
        guard let email = emailField.text, let password = passwordField.text,let confirmPassword = confirmPasswordField.text else {
            print ("資料登入錯誤")
            return
        }
        
        if password != confirmPassword {
            print("兩次輸入不一樣")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            guard let user = user else { //FIRuser
                print("註冊失敗!! \(error)")
                return
            }
            print (" 使用者 \(user.email) 註冊成功 ！！")
        }
    }
    
    @IBAction func backToSgnInTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        
        
        
    }
}
