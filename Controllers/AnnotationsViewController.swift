//
//  AnnotationsViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 8/1/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
class AnnotationsViewController: UIViewController{
    var img: UIImage?
    @IBOutlet weak var imerge: UIImageView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    var annotations: [Annotation]?
    override func viewDidLoad(){
        super.viewDidLoad()
        imerge.userInteractionEnabled = true
        imerge.image = img
    }
    func touchesBegan(touches: Set<UITouch>, event: UIEvent) {
        
        super.touchesBegan(touches, withEvent: event)
        
        let touch: UITouch = touches.first!
        var location: CGPoint = touch.locationInView(touch.view!)
        let frame = CGRectMake(location.x, location.y, 50, 30)
        var DynamicView=UIView(frame: frame)
        DynamicView.backgroundColor=UIColor(netHex: 0x3498db)
        DynamicView.layer.cornerRadius=5
        let text = UITextField(frame: frame)
        text.textColor = UIColor.whiteColor()
        view.addSubview(text)
        
        self.view.addSubview(DynamicView)
        if (touch.view == imerge){
            print("touchesBegan | This is an ImageView")
        }else{
            print("touchesBegan | This is not an ImageView")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
        if segue.identifier == "finished" {
            
        }
        else if segue.identifier == "cancelAnnotation"{
            
        }
    }
}