//
//  FrontPageViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class FrontPageViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startButton.backgroundColor = .clear
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
