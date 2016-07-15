//
//  ListRemindersViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/12/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit

class ListRemindersViewController: UIViewController{
    
    @IBOutlet var tableView: UITableView!
  
    override func viewDidLoad(){
        super.viewDidLoad()
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        recognizer.direction = .Right
        self.view .addGestureRecognizer(recognizer)
    }
    func swipeRight(recognizer : UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("backToStartingView", sender: self)
    }
    
    var reminders = [Reminder]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "Cancel" {
                print("Table view cell tapped")
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let reminder = reminders[indexPath.row]
                // 3
                let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
                // 4
                makeReminderViewController.reminder = reminder
            } else if identifier == "addReminder" {
                print("+ button tapped")
            }
        }
    }
    
    @IBAction func unwindToListReviewViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    
    
    
}