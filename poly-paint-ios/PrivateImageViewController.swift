//
//  PrivateImageViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/28/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PrivateImageViewController: UIViewController {
    var image: Image?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageProtectionLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image?.fullImage
        imageTitleLabel.text =  image?.title
        imageProtectionLevelLabel.text = image?.protectionLevel

    }
    

    
}
