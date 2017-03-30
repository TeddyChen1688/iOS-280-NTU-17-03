//
//  MainViewController.swift
//  Instogrom
//
//  Created by Teddy on 2017/3/30.
//  Copyright © 2017年 Denny Tsai. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBAction func signOutTapped(_ sender: Any) {
        try! FIRAuth.auth()?.signOut()
        
    }
    
}
