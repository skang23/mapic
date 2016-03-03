//
//  LogInViewController.swift
//  Mapic
//
//  Created by Suyeon Kang on 3/1/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func signInClicked(sender: AnyObject)
    {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print("User login failed.")
                print(error.localizedDescription)
            } else {
                print("User logged in successfully")
                self.performSegueWithIdentifier("loginSegue", sender: nil)

            }
         
            
        }
    }
    @IBAction func signUpClicked(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
              print("Yay, created a user!")
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("Username is taken")
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
