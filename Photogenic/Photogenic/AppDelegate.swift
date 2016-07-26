//
//  AppDelegate.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/11/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import UIKit
import IQKeyboardManager
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        return true
    }
    
    //    static func createLocalNotification(name: String, date: NSDate)
    //    {
    //        print("inside createNotification")
    //        let localNotification = UILocalNotification()
    //        localNotification.fireDate = date
    //        localNotification.applicationIconBadgeNumber += 1
    //        localNotification.soundName = UILocalNotificationDefaultSoundName
    //        localNotification.userInfo = [
    //            "message": "Don't forget about \(name)!!!"
    //        ]
    //        localNotification.alertBody = "Don't forget about \(name)!!!"
    ////        UIApplication.sharedApplication().scheduleLocalNotifications(localNotification)
    //    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //        self.takeActionWithNotification(notification)
    
    
    
    // 6
    //    func takeActionWithNotification(localNotification: UILocalNotification)
    //    {
    //        let notificationMessage = localNotification.userInfo! ["message"] as! String
    //        let alertController = UIAlertController(title: "a", message: "asdf", preferredStyle: .Alert)
    //        let remindMeLater = UIAlertAction(title: "l8r", style: .Default, handler: nil)
    //        let sureAction = UIAlertAction(title: "sure", style: .Default){ (action) -> Void in
    //            let listReminderViewController = self.window?.rootViewController as! ListRemindersViewController
    //
    //        }
    //        alertController.addAction(remindMeLater)
    //        alertController.addAction(sureAction)
    //        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    //    }
    
    
    
}

