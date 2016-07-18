//
//  MakeReminderViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/12/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
class MakeReminderViewController: UIViewController{
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        print("inside donetapped")
        self.performSegueWithIdentifier("done", sender: self)
    }
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        print("canceltapped")
        self.performSegueWithIdentifier("cancel", sender: self)
    }
    @IBOutlet var backgroundImage: UIImageView!
    var reminder: Reminder?
    @IBOutlet var time: UILabel!
    var keyboardOffset = 80.0
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet var name: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var shareWith: UILabel!
    @IBOutlet var shareWithTextField: UITextField!
    @IBOutlet var reminderDescription: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    var daet = ""
    var img : UIImage!
    @IBAction func exit(){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: #selector(MakeReminderViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        backgroundImage.image = self.img
        datePicker.minimumDate = NSDate()
        
        self.view.addGestureRecognizer(tapGesture)
        nameTextField.backgroundColor = UIColor.clearColor()
        shareWithTextField.backgroundColor = UIColor.clearColor()
        reminderDescription.backgroundColor = UIColor.clearColor()
        datePicker.backgroundColor = UIColor.clearColor()
        if let reminder = reminder{
            self.backgroundImage.image = self.img
        }
    }
    //Changes the label for the date whenever the time scroll wheel changes
    func datePickerChanged(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
        daet = strDate
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
            newReminder.time = time.text!
            newReminder.img = UIImagePNGRepresentation(self.img)
            if let reminder = reminder {
                // 1
                //                listRemindersViewController.tableView.reloadData()
                RealmHelper.updateReminder(reminder, newReminder: newReminder)
            } else {
                // if note does not exist, create new note
                print("Done button tapped")
                RealmHelper.addReminder(newReminder)
                
            }
            //            listRemindersViewController.reminders = RealmHelper.retrieveReminders()
        }else if segue.identifier == "cancel"{
            print("cancelled new Post")
        }
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