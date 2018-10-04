//
//  LoginViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-03.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var authenticationFailedNotice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticationFailedNotice.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTapped(_ sender: UIButton) {
        // Authentication
        // If success, go to MainMenuViewController
        // If failure set authenticationFailedNotice label
        if username.text != "" && password.text != "" {
            print("username")
            performSegue(withIdentifier: "toMainMenu", sender: self)
        } else if username.text == "" || password.text == "" {
            self.authenticationFailedNotice.text = "Please, fill all the fields above."
        } else  {
            self.authenticationFailedNotice.text = "Wrong username or password."
        }
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
