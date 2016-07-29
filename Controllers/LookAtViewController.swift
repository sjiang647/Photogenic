//
//  LookAtViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/29/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit

class LookAtViewController: UIViewController{
    var img: UIImage?
    
    @IBOutlet weak var recImage: UIImageView!
    
    override func viewDidLoad() {
        recImage.image = img
    }
}
