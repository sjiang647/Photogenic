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
        print(self.reminder?.annotations)
        print(reminder!.annotations.count)
        if reminder!.annotations.count == 0 {
            reminder!.annotations = List<Annotation>()
            
        } else {
            for ann in reminder!.annotations{
                let pt = CGPointFromString(ann.coordStringFormat!)

                let frame = CGRectMake(pt.x, pt.y, 150, 30)
                
                let DynamicView=UIView(frame: frame)
                self.arrayOfDynamicViews.append(DynamicView)
                DynamicView.backgroundColor=UIColor.clearColor()
                //            (netHex: 0x00ADDB)
                DynamicView.layer.cornerRadius=10
                let del = IdentifiedButton(frame: CGRectMake(pt.x+120, pt.y, 30, 30))
                del.tag = self.arrayOfDynamicViews.count - 1
                del.tag2 = reminder!.annotations.count
                del.backgroundColor = UIColor.clearColor()
                //                UIColor(netHex: 0x00ADDB)
                del.setImage(UIImage(named: "Icon-60"), forState:  UIControlState.Normal)
                del.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
                let text = UITextField(frame: CGRectMake(5,0,100,30))
                text.textColor = UIColor(netHex: 0xDCDFE0)
                if ann.text == ""{
                    text.text = ""
                }else{
                    text.text = ann.text
                }

                let imag = UIImageView(image: UIImage(named: "Rectangle 4"))
                imag.makeBlurImage(imag)
                imag.layer.cornerRadius = 10
                imag.layer.masksToBounds = true

                imag.frame = CGRectMake(-5, 0, 160, 30)
                DynamicView.addSubview(imag)
                DynamicView.addSubview(text)
                self.view.addSubview(DynamicView)
                self.view.addSubview(del)

                
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
            DynamicView.backgroundColor=UIColor.clearColor()
//            (netHex: 0x00ADDB)
            DynamicView.layer.cornerRadius=10
            let del = IdentifiedButton(frame: CGRectMake(point!.x+120, point!.y, 30, 30))
            del.tag = self.arrayOfDynamicViews.count - 1
            del.tag2 = reminder!.annotations.count
            del.backgroundColor = UIColor.clearColor()
//                UIColor(netHex: 0x00ADDB)
            del.setImage(UIImage(named: "Icon-60"), forState:  UIControlState.Normal)
            del.addTarget(self, action: #selector(handleButton), forControlEvents: .TouchUpInside)
            let text = UITextField(frame: CGRectMake(5,0,100,30))
            text.textColor = UIColor(netHex: 0xDCDFE0)
            text.delegate = self
            text.becomeFirstResponder()
            let imag = UIImageView(image: UIImage(named: "Rectangle 4"))
            imag.frame = CGRectMake(-5, 0, 160, 30)
            imag.makeBlurImage(imag)
            imag.layer.cornerRadius = 10
            imag.layer.masksToBounds = true

            DynamicView.addSubview(imag)
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
                    makeReminderViewController.reminder = self.reminder!
        }
        else if segue.identifier == "cancelAnnotation"{
            
        }
    }
}


extension AnnotationsViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        let realm = try! Realm()
        try! realm.write(){
            lastAnnotation.text = textField.text
        }
    }
}