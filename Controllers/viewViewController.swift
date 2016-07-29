//
//  viewViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/29/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
class viewViewController: UIViewController{
    var img: UIImage?
    @IBOutlet weak var recImage: UIImageView!
    override func viewDidLoad() {
        recImage.image = img
    }
}