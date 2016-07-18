//
//  ListRemindersViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/12/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class ListRemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    var reminders: Results<Reminder>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //swipe recognition
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        recognizer.direction = .Right
        self.view .addGestureRecognizer(recognizer)
        //get reminders
        self.reminders = RealmHelper.retrieveReminders()
        
    }
    //swipe recognition
    func swipeRight(recognizer : UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("backToStartingView", sender: self)
    }
    
    
    //number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
   // var imers: UIImage?
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listRemindersTableViewCell", forIndexPath: indexPath) as! ListRemindersTableViewCell
        //display what is on the table view
        let row = indexPath.row
        let reminder = reminders[row]
        //setters
        cell.cellName.text = reminder.name
        //imer is converting the img NSData from the reminder model to a UIImage to display in the background
        let imer: UIImage? = UIImage(data: reminder.img!)
        cell.cellTime.text = reminder.time
        cell.cellDescription.text = reminder.reminderDescription
        cell.backgroundImage.image = imer
//        if let image = imer{
//            imers = imer
//        }
        /**
         //delete comment section if want to add modificationTimeLabel
         cell.noteModificationTimeLabel.text = note.modificationTime.convertToString()
         **/
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 2
        if editingStyle == .Delete {
            RealmHelper.deleteReminder(reminders[indexPath.row])
            //2
            reminders = RealmHelper.retrieveReminders()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //check if segue has identifier
        if let identifier = segue.identifier {
            //what to execute when identifier = cancel
            if identifier == "editReminder" {
                print("Table view cell tapped")
                let indexPath = tableView.indexPathForSelectedRow!
                let reminderCell = reminders[indexPath.row]
                let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
                makeReminderViewController.reminder = reminderCell
               // makeReminderViewController.backgroundImage.image = imers
            } else if identifier == "addReminder" {
                print("+ button tapped")
                
            }
        }
    }
    @IBAction func unwindToListReviewViewController(segue: UIStoryboardSegue) {
        //unwind segue for makeReminder to call to unwind back to list reminder
    }
    
    
}