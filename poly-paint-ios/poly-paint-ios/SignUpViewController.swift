//
//  SignUpViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-03.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _confirmPassword: UITextField!
    @IBOutlet weak var _signUpFailedNotice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._signUpFailedNotice.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        if _username.text == "" || _password.text == "" || _confirmPassword.text == "" {
            self._signUpFailedNotice.text = "Please, fill all the fields above."
        } else if _password.text != _confirmPassword.text {
            self._signUpFailedNotice.text = "The username and password don't match."
        } else {
             performSegue(withIdentifier: "toMainMenu", sender: self)
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
