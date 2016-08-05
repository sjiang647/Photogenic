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
    var reminder: Reminder?
    //    var getAnnotation: Annotation?
    
    var lastAnnotation : Annotation!
    
    @IBOutlet weak var imerge: UIImageView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    //   let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("inside viewWillAppear Annotations")
//        print(self.reminder)
//        let stringu = "{72.5, 218}"
//        let point = CGPointFromString(stringu)
//        let framer = CGRectMake(point.x, point.y, 150, 30)
//        let viee = UIView(frame: framer)
//        viee.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(viee)
        print(self.reminder?.annotations)
        print(reminder!.annotations.count)
        if reminder!.annotations.count == 0 {
            reminder!.annotations = List<Annotation>()
            
        } else {
            for ann in reminder!.annotations{
                let pt = CGPointFromString(ann.coordStringFormat!)
                let frame = CGRectMake(pt.x, pt.y, 150, 30)
                let DynamicView=UIView(frame: frame)
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
            
        }
        
    }
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        print("viewdidappearannotations")
    }
    var arrayOfDynamicViews :[UIView] = []
    override func viewDidLoad(){
        super.viewDidLoad()
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
            let del = IdentifiedButton(frame: CGRectMake(point!.x+100, point!.y, 50, 30))
            del.tag = self.arrayOfDynamicViews.count - 1
            del.tag2 = reminder!.annotations.count
            del.backgroundColor = UIColor.whiteColor()
            del.setTitle("delete", forState: UIControlState.Normal)
            //            del.
            del.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
            let text = UITextField(frame: CGRectMake(0,0,100,30))
            text.delegate = self
            text.becomeFirstResponder()
            DynamicView.addSubview(text)
            self.view.addSubview(DynamicView)
            self.view.addSubview(del)
            let newAnnotation = Annotation()
            lastAnnotation = newAnnotation
            print("annotation instantiated")
            newAnnotation.coordStringFormat = NSStringFromCGPoint(point!)
            print("coordSet")
            print("textSet")
            let realm = try! Realm()
            try! realm.write(){
                reminder!.annotations.append(newAnnotation)
            }
            print("added")
        }
    }
    func handleButton(sender: IdentifiedButton){
        self.arrayOfDynamicViews[sender.tag].removeFromSuperview()
        sender.removeFromSuperview()
        reminder!.annotations.removeAtIndex(sender.tag2)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
        if segue.identifier == "finished" {
            //            let newReminder = Reminder()
            //            newReminder.annotations = reminder!.annotations
            //            newReminder.img = reminder?.img
            //            newReminder.uuid = reminder!.uuid
            //            newReminder.doot = reminder?.doot
            //            newReminder.time = reminder!.time
            //            newReminder.name = reminder!.name
            //
            //
            //            let realm = try! Realm()
            //            try! realm.write(){
            //                reminder = newReminder
            //                //                reminder!.annotations = annotations
            //            }
            //            for anno in annotations {
            //                print(anno.text)
            //                print(anno.coordStringFormat)
            //            }
            makeReminderViewController.reminder = self.reminder!
        }
        else if segue.identifier == "cancelAnnotation"{
            
        }
    }
}


extension AnnotationsViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        self.lastAnnotation.text = textField.text
    }
}