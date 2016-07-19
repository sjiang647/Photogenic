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
class ListRemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    @IBOutlet var tableView: UITableView!
    var reminders: Results<Reminder>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func addReminder(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                //set properties for camera
                //                imagePicker.allowsEditing = false
                //                imagePicker.sourceType = .Camera
                //                imagePicker.cameraCaptureMode = .Photo
                //                imagePicker.delegate = self
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                print("no rear camera detected")
            }
        } else {
            print("camera inaccessible")
        }
        
    }
    var img:UIImage?
    var selectedRecminder:Reminder?

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            //            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
            img = pickedImage
            //            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an image
            print("imagePicker.dismiss")
            self.performSegueWithIdentifier("cameraToEdit", sender: self)
        })
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
        })
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //swipe recognition
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight:")
        recognizer.direction = .Right
        self.view .addGestureRecognizer(recognizer)
        //get reminders
        self.reminders = RealmHelper.retrieveReminders()
        //camera
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                //set properties for camera
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                imagePicker.delegate = self
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                print("no rear camera detected")
            }
        } else {
//            self.img = UIImage(named: "happiestman")
//            self.performSegueWithIdentifier("cameraToEdit", sender: self)
            print("camera inaccessible")
        }

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
        let imer = UIImage(data: reminder.img!)
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ListRemindersTableViewCell
        self.img = cell.backgroundImage.image
        self.selectedRecminder = reminders[indexPath.row]
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
                //                let indexPath = tableView.indexPathForSelectedRow!
                //                let reminderCell = reminders[indexPath.row]
                let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
                //                makeReminderViewController.reminder = reminderCell
                makeReminderViewController.img = self.img
                makeReminderViewController.reminder = self.selectedRecminder
                // makeReminderViewController.backgroundImage.image = imers
            } else if identifier == "cameraToEdit" {
                print("+ button tapped")
                 let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
                makeReminderViewController.img = img
                makeReminderViewController.reminder = self.selectedRecminder
                
            }
        }
    }
    @IBAction func unwindToListReviewViewController(segue: UIStoryboardSegue) {
        //unwind segue for makeReminder to call to unwind back to list reminder
    }
    
    
}