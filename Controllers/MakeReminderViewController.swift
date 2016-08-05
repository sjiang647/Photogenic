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
   
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
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
    var gotoAnnotationBeforeSave = false
    @IBOutlet weak var time: UILabel!
    var keyboardOffset = 80.0
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var shareWithTextField: UITextField!
    //@IBOutlet weak var reminderDescription: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var differenceBetweenDates: NSTimeInterval?
    //    var annotations: List<Annotation>?
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
        annotationTableView.backgroundColor = UIColor.clearColor()
//        self.view.addSubview(tableView)
        annotationTableView.delegate = self
        annotationTableView.dataSource = self
        print("inside Makereminder's ViewDidLoad")
        datePicker.addTarget(self, action: #selector(MakeReminderViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        backgroundImage.image = self.img
//        print("viewDidLoad")
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
        //        UINavigationBar.appearance().barTintColor = UIColor(netHex: 0x34495e)
        //        if self.reminder == nil{
        //            self.reminder = Reminder()
        //        }
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
        //        if NSDate().compare(dateNSFormat!) == NSComparisonResult.OrderedDescending{
        //            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        //        }
        if datePicker.date.compare(datePicker.minimumDate!) == .OrderedAscending {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
        dateStrFormat = strDate
        dateNSFormat = datePicker.date
        
        //  dane = datePicker.date
    }
    
    //prepareForSegue for unwind back into listReminders
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "done" {
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
            if reminder!.annotations.count == 0{
            }else{
                newReminder.annotations = self.reminder!.annotations
                
            }
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            if let reminder = reminder {
                if gotoAnnotationBeforeSave {
                    dispatch_async(backgroundQueue, {
                        let realm = try! Realm()
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
        print("inside makeReminder's viewWillAppear")
        print(self.reminder?.annotations.count)
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
    // var imers: UIImage?
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("annotationTableViewCell", forIndexPath: indexPath) as! AnnotationTableViewCell
        //display what is on the table view
        let row = indexPath.row
        if reminder != nil{
            let annotation = reminder!.annotations[row]
            //setters
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
        
        //        self.sentAnnotation = cell.annotation
        //
        //        self.date = String.backToDate(cell.cellTime.text!)
        //        self.selectedRecminder = reminders[indexPath.row]
        //        print(indexPath.row)
        //        print(self.selectedRecminder?.name)
        //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //        self.performSegueWithIdentifier("cameraToEdit", sender: self)
        // self.performSegueWithIdentifier("dispAnnotation", sender: self)
        
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