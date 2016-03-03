//
//  AccountViewController.swift
//  Mapic
//
//  Created by Suyeon Kang on 3/2/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit
import Parse
class AccountViewController: UIViewController {

    @IBAction func logoutClicked(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("toLogIn", sender: sender)
        
    }
}
