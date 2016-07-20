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


class MakeReminderViewController: UIViewController{
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        print("inside donetapped")
        self.performSegueWithIdentifier("done", sender: self)
    }
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        print("canceltapped")
        self.performSegueWithIdentifier("cancel", sender: self)
    }
    @IBOutlet weak var backgroundImage: UIImageView!
    var reminder: Reminder?
    @IBOutlet weak var time: UILabel!
    var keyboardOffset = 80.0
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var shareWith: UILabel!
    @IBOutlet weak var shareWithTextField: UITextField!
    @IBOutlet weak var reminderDescription: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var dane: NSDate?
    var daet = ""
    var img : UIImage?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: #selector(MakeReminderViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        backgroundImage.image = self.img
        print("viewDidLoad")
        print(self.reminder?.name)
        
        datePicker.minimumDate = NSDate()
        
        
        self.view.addGestureRecognizer(tapGesture)
        //label colors
        nameTextField.backgroundColor = UIColor.clearColor()
        shareWithTextField.backgroundColor = UIColor.clearColor()
        reminderDescription.backgroundColor = UIColor.clearColor()
        datePicker.backgroundColor = UIColor.clearColor()
       
    }
    //Changes the label for the date whenever the time scroll wheel changes
    func datePickerChanged(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
        daet = strDate
        dane = datePicker.date
    }
    
    //prepareForSegue for unwind back into listReminders
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listRemindersViewController = segue.destinationViewController as! ListRemindersViewController
        print("prepareFor")
        
        
        
        if segue.identifier == "done" {
            // if note exists, update title and content
            let newReminder = Reminder()
            newReminder.name = nameTextField.text ?? "Untitled"
            newReminder.reminderDescription = reminderDescription.text ?? "No Description.."
            newReminder.time = daet
            newReminder.tiem = dane
            newReminder.img = UIImagePNGRepresentation(self.img!)
            if let reminder = reminder {
                RealmHelper.updateReminder(reminder, newReminder: newReminder)
            } else {
                // if note does not exist, create new note
                print("Done button tapped")
                RealmHelper.addReminder(newReminder)
                
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
        // 1
        if let reminder = reminder {
            // 2
            nameTextField.text = reminder.name
            reminderDescription.text = reminder.reminderDescription
            time.text = daet
            datePicker.date = dane!
            shareWithTextField.text = ""
        } else {
            // 3
            
            nameTextField.text = ""
            reminderDescription.text = ""
            time.text = daet
            shareWithTextField.text = ""
        }
        
    }
    
    
    
    
    
}