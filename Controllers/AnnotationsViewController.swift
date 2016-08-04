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
import RealmSwift

class AnnotationsViewController: UIViewController,  UIGestureRecognizerDelegate{
    var img: UIImage?
    var point: CGPoint?
    var getAnnotation: Annotation?
    var annotations: List<Annotation>?
    @IBOutlet weak var imerge: UIImageView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
//   let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
    
    var arrayOfDynamicViews :[UIView] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if annotations != nil {
            for ann in annotations!{
                let pt = CGPointFromString(ann.coordStringFormat!)
                let frame = CGRectMake(pt.x, pt.y, 150, 30)
                var DynamicView=UIView(frame: frame)
                DynamicView.backgroundColor=UIColor(netHex: 0x3498db)
                DynamicView.layer.cornerRadius=10
                let text = UITextField(frame: CGRectMake(0,0,150,30))
                if ann.text == ""{
                    text.text = ""
                }else{
                    text.text = ann.text
                }
                DynamicView.addSubview(text)
                self.view.addSubview(DynamicView)
            }
        }else{
            annotations = List<Annotation>()
        }
        imerge.image = img
        imerge.userInteractionEnabled = true
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
    }
    func handleTap(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            point = tapGestureRecognizer.locationInView(imerge)
            print("tapRecognized")
            print(NSStringFromCGPoint(point!))
           
            let frame = CGRectMake(point!.x, point!.y, 150, 30)
            
            let DynamicView=UIView(frame: frame)
            self.arrayOfDynamicViews.append(DynamicView)
            DynamicView.backgroundColor=UIColor(netHex: 0x3498db)
            DynamicView.layer.cornerRadius=10
            let del = UIButton(frame: CGRectMake(point!.x+100, point!.y, 50, 30))
            del.tag = self.arrayOfDynamicViews.count - 1
            del.backgroundColor = UIColor.whiteColor()
            del.setTitle("delete", forState: UIControlState.Normal)
//            del.
            del.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
            let text = UITextField(frame: CGRectMake(0,0,100,30))
            text.becomeFirstResponder()
            DynamicView.addSubview(text)
            self.view.addSubview(DynamicView)
            self.view.addSubview(del)
//            var newAnnotation: Annotation?
//            newAnnotation!.coordStringFormat = NSStringFromCGPoint(point!)
//            newAnnotation!.text = text.text
//            annotations!.append(newAnnotation!)
        }
    }
    func handleButton(sender: UIButton){
        self.arrayOfDynamicViews[sender.tag].removeFromSuperview()
        sender.removeFromSuperview()
    }
    
//    func touchesBegan(touches: Set<UITouch>, event: UIEvent) {
//        
//        super.touchesBegan(touches, withEvent: event)
//        
//        let touch: UITouch = touches.first!
//        var location: CGPoint = touch.locationInView(touch.view!)
//        let frame = CGRectMake(location.x, location.y, 50, 30)
//        var DynamicView=UIView(frame: frame)
//        DynamicView.backgroundColor=UIColor(netHex: 0x3498db)
//        DynamicView.layer.cornerRadius=5
//        let text = UITextField(frame: frame)
//        text.textColor = UIColor.whiteColor()
//        view.addSubview(text)
//        
//        self.view.addSubview(DynamicView)
//        if (touch.view == imerge){
//            print("touchesBegan | This is an ImageView")
//        }else{
//            print("touchesBegan | This is not an ImageView")
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
        if segue.identifier == "finished" {
        makeReminderViewController.annotations = annotations!
        }
        else if segue.identifier == "cancelAnnotation"{
            
        }
    }
}