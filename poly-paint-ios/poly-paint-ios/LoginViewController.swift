//
//  LoginViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-03.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var _username: UITextField!
    @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _authenticationFailedNotice: UILabel!
    @IBOutlet weak var _loginButton: UIButton!
    
    @IBOutlet weak var _usernameSignUp: UITextField!
    @IBOutlet weak var _passwordSignUp: UITextField!
     @IBOutlet weak var _confirmPasswordSignUp: UITextField!
    @IBOutlet weak var _signUpFailedNotice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _authenticationFailedNotice.text = ""
        _signUpFailedNotice.text = ""
        
        let preferences = UserDefaults.standard
        
        if(preferences.object(forKey: "username") != nil) {
            //loginDone()
        } else {
            //loginToDo()
            _username.isEnabled = false
            _password.isEnabled = false
            _loginButton.isEnabled = false
        }
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
        let username = _username.text
        let password = _password.text
        
        if username != "" && password != "" {
            performSegue(withIdentifier: "toMainMenu", sender: self)
            //doLogin(username!, password!)
        } else if username == "" || password == "" {
            _authenticationFailedNotice.text = "Please, fill all the fields above."
        } else  {
            _authenticationFailedNotice.text = "Wrong username or password."
        }
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        UserDefaults.standard.set("anonymous", forKey: "username")
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
    
    func doLogin(_ user: String, _ psw: String) {
        let url = URL(string: "http://ec2-18-214-40-211.compute-1.amazonaws.com")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username" + user + "&password" + psw
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else {
                return
            }
            
            let json:Any?
            
            do {
               json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            guard let serverResponse = json as? NSDictionary else {
                return
            }
            
            if let dataBlock = serverResponse["data"] as? NSDictionary {
                if let sessionData = dataBlock["session"] as? String {
                    let preferences = UserDefaults.standard
                    preferences.set(sessionData, forKey: "session")
                    
                    DispatchQueue.main.async {
                       _ = self.loginDone
                    }
                }
            }
        })
        
        task.resume()
        //performSegue(withIdentifier: "toMainMenu", sender: self)
    }
    
    func loginToDo() {
        _username.isEnabled = true
        _password.isEnabled = true
        _loginButton.setTitle("Login", for: .normal)
    }
    
    func loginDone() {
        _username.isEnabled = false
        _password.isEnabled = false
        _loginButton.setTitle("Logout", for: .normal)
        _authenticationFailedNotice.text = ""
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let username = _usernameSignUp.text
        let password = _passwordSignUp.text
        let confirmPassword = _confirmPasswordSignUp.text
        
        if username == "" || password == "" || confirmPassword == "" {
            self._signUpFailedNotice.text = "Please, fill all the fields above."
        } else if password != confirmPassword {
            self._signUpFailedNotice.text = "The username and password don't match."
        } else {
            //signUp(username!, password!)
            performSegue(withIdentifier: "toMainMenu", sender: self)
        }
    }
    
    func signUp(_ username: String, _ password: String) {
        let url = URL(string: "http://ec2-18-214-40-211.compute-1.amazonaws.com")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username" + username + "&password" + password
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else {
                return
            }
            
            let json:Any?
            
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            guard let serverResponse = json as? NSDictionary else {
                return
            }
            
            if let dataBlock = serverResponse["data"] as? NSDictionary {
                if (dataBlock["session"] as? String) != nil {
                    DispatchQueue.main.async {
                        // segue successful login
                    }
                }
            }
        })
        
        task.resume()
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
