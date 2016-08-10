//
//  MakeReminderViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/12/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import BSForegroundNotification
import AudioToolbox
import MGSwipeTableCell
class MakeReminderViewController: UIViewController, UITextViewDelegate,UITableViewDelegate, UITableViewDataSource, BSForegroundNotificationDelegate{
    
    
    @IBOutlet weak var annotationTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    var reminder: Reminder?
    var gotoAnnotationBeforeSave = false
    @IBOutlet weak var time: UILabel!
    var keyboardOffset = 80.0
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var differenceBetweenDates: NSTimeInterval?
    var dateNSFormat: NSDate?
    var dateStrFormat = ""
    var img : UIImage?
    private func userInfoForCategory(category: String) -> [NSObject: AnyObject] {
        
        return ["aps": [
            "category": category,
            "alert": [
                "body": "Don't forget about \(nameTextField.text!)",
                "title": "Photogenic"
            ],
            "sound": "sound.wav"
            ]
        ]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        annotationTableView.backgroundColor = UIColor.clearColor()
        annotationTableView.delegate = self
        annotationTableView.dataSource = self
        print("inside Makereminder's ViewDidLoad")
        datePicker.addTarget(self, action: #selector(MakeReminderViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurEffectView)
        backgroundImage.image = self.img
        print(self.reminder?.name)
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Minute, value: 5, toDate: NSDate(), options: [])
        datePicker.minimumDate = date
        self.view.addGestureRecognizer(tapGesture)
        nameTextField.backgroundColor = UIColor.clearColor()
        datePicker.backgroundColor = UIColor.clearColor()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
        datePicker.setValue(1, forKeyPath: "alpha")
    }
    
    //Changes the label for the date whenever the time scroll wheel changes
    func datePickerChanged(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        if datePicker.date.compare(datePicker.minimumDate!) == .OrderedAscending {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
        dateStrFormat = strDate
        dateNSFormat = datePicker.date
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "done" {
            print("inside donetapped")
            let pickerDate = self.datePicker.date
            let currentDate = NSDate()
            differenceBetweenDates = datePicker.date.timeIntervalSinceDate(currentDate)
            let localNotification = UILocalNotification()
            localNotification.fireDate = pickerDate
            //        localNotification.applicationIconBadgeNumber += 1
            localNotification.alertBody = "Don't forget about \(nameTextField.text!)!!!"
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.category = ("BACKGROUND_NOTIF")
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: self)
//            BSForegroundNotification.systemSoundID = 1001
//            let notif = BSForegroundNotification(userInfo: userInfoForCategory("ONE_BUTTON"))
//            
//            let triggerDate = Int64(differenceBetweenDates! * Double(NSEC_PER_SEC))
//            print(triggerDate)
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                triggerDate)
//            , dispatch_get_main_queue()){ () -> Void in
//                notif.presentNotification()
//            }
//            notif.delegate = self
            
            print("reminder is nil")
            //            self.performSegueWithIdentifier("done", sender: self)
            
            let listRemindersViewController = segue.destinationViewController as! ListRemindersViewController
            print("prepareFor")
            
            
            // if note exists, update title and content
            let newReminder = Reminder()
            newReminder.name = nameTextField.text ?? "Untitled"
            //            newReminder.reminderDescription = reminderDescription.text ?? "No Description.."
            newReminder.time = dateStrFormat
            newReminder.doot = dateNSFormat
            print(newReminder.doot)
            print(newReminder.time)
            newReminder.img = UIImagePNGRepresentation(self.img!)
            if self.reminder == nil{
            }else{
                if self.reminder!.annotations.count == 0 {
                }else{
                    newReminder.annotations = self.reminder!.annotations
                }
            }
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            if let reminder = reminder {
                if gotoAnnotationBeforeSave {
                    dispatch_async(backgroundQueue, {
                        let realm = try! Realm()
//                        print(realm.getPath())
                        try! realm.write(){
                            realm.add(newReminder)
                        }
                    })
                    
                } else {
                    let reminderUUID = reminder.uuid
                    dispatch_async(backgroundQueue, {
                        let realm = try! Realm()
                        
                        try! realm.write(){
                            if let reminderFromRealm = realm.objectForPrimaryKey(Reminder.self, key: reminderUUID) {
                                reminderFromRealm.name = newReminder.name
                                //  reminderToBeUpdated.reminderDescription = newReminder.reminderDescription
                                reminderFromRealm.time = newReminder.time
                                reminderFromRealm.img = newReminder.img
                                //  reminderToBeUpdated.tiem = newReminder.tiem
                                reminderFromRealm.doot = newReminder.doot
                            }
                            
                        }
                        
                    })
                    
                }
                
            } else {
                // if note does not exist, create new note
                print("Done button tapped")
                dispatch_async(backgroundQueue, {
                    let realm = try! Realm()
                    try! realm.write(){
                        realm.add(newReminder)
                    }
                })
                
                
            }
            
            
        }else if segue.identifier == "cancel"{
            print("cancelled new Post")
            
        }else if segue.identifier == "addAnnotation"{
            let annotationsViewController = segue.destinationViewController as! AnnotationsViewController
            annotationsViewController.img = self.img
            
            
            if self.reminder == nil {
                self.gotoAnnotationBeforeSave = true
                let reminder = Reminder()
                
                reminder.name = nameTextField.text!
                //            reminderDescription.text = reminder.reminderDescription
                reminder.time = time.text!
                //datePicker.date = dane!
                //            shareWithTextField.text = ""
                reminder.doot = datePicker.date
                
                annotationsViewController.reminder = reminder
                
            } else {
                annotationsViewController.reminder = self.reminder
            }
            
            
        }
        
    }
    
    
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        self.view.insertSubview(blurEffectView, atIndex: 0)

        print("inside makeReminder's viewWillAppear")
        print(self.reminder?.annotations.count)
        // 1
        if let reminder = reminder {
            // 2
            nameTextField.text = reminder.name
            time.text = reminder.time
            datePicker.setDate(dateNSFormat!, animated: true)
            datePicker.date = dateNSFormat!
            
        } else {
            nameTextField.text = ""
            time.text = ""
            dateNSFormat = datePicker.date
        }
        annotationTableView.reloadData()
    }
    @IBAction func unwindToMakeReminderViewController(segue: UIStoryboardSegue) {
        //unwind segue for makeReminder to call to unwind back to list reminder
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reminder == nil{
            return 0
        }else{
            return self.reminder!.annotations.count
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("annotationTableViewCell", forIndexPath: indexPath) as! AnnotationTableViewCell
        let row = indexPath.row
        if reminder != nil{
            let annotation = reminder!.annotations[row]
            cell.annotationText.text = annotation.text
            cell.num.text = "\(indexPath.row + 1)."
            //imer is converting the img NSData from the reminder model to a UIImage to display in the background
            
            cell.backgroundColor = UIColor.clearColor()
            cell.rightButtons = [MGSwipeButton(title: "", icon: UIImage(named: "Icon-61.png"), backgroundColor: UIColor(netHex: 0xe74c3c), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                self.reminder!.annotations.removeAtIndex(indexPath.row)
                //            RealmHelper.deleteReminder(self.reminders[indexPath.row])
                //            self.reminders = RealmHelper.retrieveReminders()
                return true
            })]
            cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
            
            
        }
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AnnotationTableViewCell
    }
    
    
    @IBAction func addAnnotation(sender: AnyObject) {
        self.performSegueWithIdentifier("addAnnotation", sender: self)
    }
    
    
}
extension NSDate {
    func convertToString() -> String {
        return NSDateFormatter.localizedStringFromDate(self, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
    }
}
extension String{
    static func backToDate(string:String) -> NSDate{
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.dateFormat = "MMM dd,yy, HH:mm:ss a"
        formatter
        let dateString: NSDate = formatter.dateFromString(string)!
        return dateString
    }
    
}