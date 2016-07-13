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
  
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "Cancel" {
                print("Table view cell tapped")
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