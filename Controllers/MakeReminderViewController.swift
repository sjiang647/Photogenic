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
class MakeReminderViewController: UIViewController, UITextViewDelegate, BSForegroundNotificationDelegate{
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        print("inside donetapped")
        let pickerDate = self.datePicker.date
        if let string = nameTextField.text{
            nameTextField.text = nameTextField.text
        }else{
            nameTextField.text = "reminder at \(pickerDate)"
        }
        let currentDate = NSDate()
        differenceBetweenDates = datePicker.date.timeIntervalSinceDate(currentDate)
        let localNotification = UILocalNotification()
        localNotification.fireDate = pickerDate
        //        localNotification.applicationIconBadgeNumber += 1
        localNotification.alertBody = "Don't forget about \(nameTextField.text!)!!!"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadData", object: self)
        BSForegroundNotification.systemSoundID = 1001
        let notif = BSForegroundNotification(userInfo: userInfoForCategory("ONE_BUTTON"))
        
        let triggerDate = Int64(differenceBetweenDates! * Double(NSEC_PER_SEC))
        print(triggerDate)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            triggerDate)
        , dispatch_get_main_queue()){ () -> Void in
            notif.presentNotification()
        }
        notif.delegate = self
        
        print("reminder is nil")
        self.performSegueWithIdentifier("done", sender: self)
        
    }
    
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        print("canceltapped")
        self.performSegueWithIdentifier("cancel", sender: self)
    }
    //var appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    var reminder: Reminder?
    @IBOutlet weak var time: UILabel!
    var keyboardOffset = 80.0
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var shareWithTextField: UITextField!
    //@IBOutlet weak var reminderDescription: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var differenceBetweenDates: NSTimeInterval?
    
    var dateNSFormat: NSDate?
    var dateStrFormat = ""
    var img : UIImage?
    //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
        print("insideViewDidLoad")
        datePicker.addTarget(self, action: #selector(MakeReminderViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        backgroundImage.image = self.img
        print("viewDidLoad")
        print(self.reminder?.name)
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Minute, value: 5, toDate: NSDate(), options: [])     // used to be `.CalendarUnitMinute`
        datePicker.minimumDate = date
        
        self.view.addGestureRecognizer(tapGesture)
        //label colors
        nameTextField.backgroundColor = UIColor.clearColor()
        //        shareWithTextField.backgroundColor = UIColor.clearColor()
        //        reminderDescription.backgroundColor = UIColor.clearColor()
        datePicker.backgroundColor = UIColor.clearColor()
        //        self.reminderDescription.layer.borderColor = UIColor.blackColor().CGColor
        //        self.reminderDescription.layer.borderWidth = 1.0
        
        differenceBetweenDates = 310.0
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
        datePicker.setValue(0.8, forKeyPath: "alpha")
        UINavigationBar.appearance().barTintColor = UIColor(netHex: 0x34495e)
        
    }
    
    
    
    //    func textViewDidChange(textView: UITextView) {
    //        self.descriptionLabel.hidden = reminderDescription.text.characters.count > 0
    //    }
    //
    //    func textViewDidEndEditing(textView: UITextView) {
    //        self.descriptionLabel.hidden = reminderDescription.text.characters.count > 0
    //    }
    //
    
    //Changes the label for the date whenever the time scroll wheel changes
    func datePickerChanged(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
        dateStrFormat = strDate
        dateNSFormat = datePicker.date
        if dateNSFormat!.compare(NSDate()) == NSComparisonResult.OrderedDescending{
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        //  dane = datePicker.date
    }
    
    //prepareForSegue for unwind back into listReminders
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listRemindersViewController = segue.destinationViewController as! ListRemindersViewController
        print("prepareFor")
        
        
        
        if segue.identifier == "done" {
            // if note exists, update title and content
            let newReminder = Reminder()
            newReminder.name = nameTextField.text ?? "Untitled"
            //            newReminder.reminderDescription = reminderDescription.text ?? "No Description.."
            newReminder.time = dateStrFormat
            newReminder.doot = dateNSFormat
            print(newReminder.doot)
            print(newReminder.time)
            newReminder.img = UIImagePNGRepresentation(self.img!)
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            if let reminder = reminder {
                let reminderUUID = reminder.uuid
                dispatch_async(backgroundQueue, {
                    let realm = try! Realm()
                    
                    try! realm.write(){
                        let reminderFromRealm = realm.objectForPrimaryKey(Reminder.self, key: reminderUUID)!
                        reminderFromRealm.name = newReminder.name
                        //            reminderToBeUpdated.reminderDescription = newReminder.reminderDescription
                        reminderFromRealm.time = newReminder.time
                        reminderFromRealm.img = newReminder.img
                        //  reminderToBeUpdated.tiem = newReminder.tiem
                        reminderFromRealm.doot = newReminder.doot
                    }
                    
                })
                
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
        }
        //        listRemindersViewController.reminders = RealmHelper.retrieveReminders()
    }
    
    //        if let identifier = segue.identifier {
    //            if identifier == "Cancel" {
    //                print("Cancel button tapped")
    //
    //            } else if identifier == "Done" {
    //                if let reminder = reminder{
    //                    reminder.name = nameTextField.text ?? "Untitled"
    //                    reminder.reminderDescription = reminderDescription.text ?? "No Description.."
    //                    reminder.time = time.text!
    //                    listRemindersViewController.tableView.reloadData()
    //                }else{
    //
    //                    print("Done button tapped")
    //                    let reminder = Reminder()
    //                    reminder.name = name.text ?? "Untitled"
    //                    reminder.reminderDescription = reminderDescription.text ?? "No Description.."
    //                    reminder.time = time.text!
    //                    listRemindersViewController.reminders.append(reminder)
    //                }
    //            }
    //        }
    //     }
    
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("inside viewWillAppear")
        
        // 1
        if let reminder = reminder {
            // 2
            nameTextField.text = reminder.name
            //            reminderDescription.text = reminder.reminderDescription
            time.text = reminder.time
            //datePicker.date = dane!
            //            shareWithTextField.text = ""
            datePicker.setDate(dateNSFormat!, animated: true)
            datePicker.date = dateNSFormat!
            
        } else {
            // 3
            
            nameTextField.text = ""
            //            reminderDescription.text = ""
            time.text = ""
            // datePicker.date = dane!
            //datePicker.setDate(dateNSFormat!, animated: true)
            //            shareWithTextField.text = ""
            dateNSFormat = datePicker.date
        }
        
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