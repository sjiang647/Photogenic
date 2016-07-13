//
//  StartingViewViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/12/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit

class StartingViewViewController: UIViewController{
    
    @IBOutlet var cameraView: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    //take picture
    
//    @IBAction func takePicture(sender: AnyObject) {
//        //check if camera is available
//        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
//            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
//                //set properties for camera
//                imagePicker.allowsEditing = false
//                imagePicker.sourceType = .Camera
//                imagePicker.cameraCaptureMode = .Photo
//                presentViewController(imagePicker, animated: true, completion: {})
//            } else {
//               print("no rear camera detected")
//            }
//        } else {
//            print("camera inaccessible")
//        }
//        
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an image
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
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                print("no rear camera detected")
            }
        } else {
            print("camera inaccessible")
        }

    }
}