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
  
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var shareWith: UILabel!
    @IBOutlet var shareWithTextField: UITextField!
    
    @IBOutlet var reminderDescription: UITextView!
   
    @IBOutlet var datePicker: UIDatePicker!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: #selector(MakeReminderViewController.datePickerChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        datePicker.minimumDate = NSDate()
    }
    //Changes the label for the date whenever the time scroll wheel changes
    func datePickerChanged(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        time.text = strDate
    }

    //prepareForSegue for unwind back into listReminders
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "Cancel" {
                print("Cancel button tapped")
            } else if identifier == "Done" {
                print("Done button tapped")
            }
        }
    }
    
    
}