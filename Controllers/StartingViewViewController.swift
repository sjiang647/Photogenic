//
//  StartingViewViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/12/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit

class StartingViewViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var img: UIImage?
    @IBAction func goToFriends(sender: AnyObject) {
        self.performSegueWithIdentifier("showFriends", sender: self)
    }
    @IBOutlet weak var cameraView: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    //take picture
    
    @IBAction func takePicture(sender: AnyObject) {
        //check if camera is available
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
            self.img = UIImage(named: "happiestman")
            self.performSegueWithIdentifier("cameraToEdit", sender: self)
            print("camera inaccessible")
        }
        
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft:")
        recognizer.direction = .Left
        self.view .addGestureRecognizer(recognizer)
        
        
    }
    func swipeLeft(recognizer : UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("goToList", sender: self)
    }
    
    @IBAction func unwindToStartingViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "cameraToEdit" {
                print("Going to Edit")
                
                let makeReminderViewController = segue.destinationViewController as! MakeReminderViewController
                makeReminderViewController.img = img
            }
        }
        
    }
    
    
}