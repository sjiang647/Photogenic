//
//  LookAtViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/29/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
class LookAtViewController: UIViewController{
    var img: UIImage?
    var rem: Reminder?
    @IBOutlet weak var recImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.recImage.contentMode = .ScaleAspectFit
        recImage.image = img
        
        for ann in rem!.annotations{
            let pt = CGPointFromString(ann.coordStringFormat!)
            let frame = CGRectMake(pt.x, pt.y, 150, 30)
            let DynamicView=UIView(frame: frame)
            DynamicView.backgroundColor=UIColor(netHex: 0x00ADDB)
            DynamicView.layer.cornerRadius=10
            let text = UITextField(frame: CGRectMake(5,0,150,30))
            text.textColor = UIColor(netHex: 0x424242)
            if ann.text == ""{
                text.text = ""
            }else{
                text.text = ann.text
            }
            DynamicView.addSubview(text)
            self.view.addSubview(DynamicView)
        }

    }
}
