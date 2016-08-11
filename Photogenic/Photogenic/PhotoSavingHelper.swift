//
//  String + Extension.swift
//  Photogenic
//
//  Created by Gelei Chen on 10/8/2016.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import UIKit

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
}

private let _sharedInstance = PhotoSavingHelper()
public class PhotoSavingHelper :NSObject {
    
    //Singleton Design
    class public var sharedInstance:PhotoSavingHelper {
        
        return _sharedInstance
        
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    private let numberOfImagesKey = "numberOfImagesKey"
    private var numberOfImages:Int!
    
    // PRIVATE : Documents directory
    private func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        return documentsFolderPath
    }
    // File in Documents directory
    private func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }
    //Save image to local directory
    func saveImage(image: UIImage, name: Int) -> Bool {
        increaseNumberOfImagesByOne()
        let compressedImage = compressTheImage(image)
        let pngImageData = UIImagePNGRepresentation(compressedImage)
        let path = fileInDocumentsDirectory("\(name).png")
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    
    //Load image from path
    func loadImageFromPath(name: String) -> UIImage? {
        let path = fileInDocumentsDirectory(name)
        let data = NSData(contentsOfFile: path)
        let image = UIImage(data: data!)
        return image
    }
    
    private func getDataFromUserDefaults(){
        if self.numberOfImages == nil {
            if let numberInUserDefaults = userDefaults.objectForKey(numberOfImagesKey) as? Int{
                self.numberOfImages = numberInUserDefaults
            } else {
                self.numberOfImages = 0
                userDefaults.setObject(0, forKey: numberOfImagesKey)
            }
        }
    }
    
    //Get current counter for numberOfImages in userDefaults
    func getNumberOfImages() -> Int {
        getDataFromUserDefaults()
        return self.numberOfImages
    }
    
    private func increaseNumberOfImagesByOne(){
        getDataFromUserDefaults()
        self.numberOfImages = self.numberOfImages + 1
        userDefaults.setObject(self.numberOfImages, forKey: numberOfImagesKey)
    }
    
    private func compressTheImage(image:UIImage)->UIImage{
        let newSize = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}