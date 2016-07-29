//
//  Reminder.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/14/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Reminder: Object{
    dynamic var doot: NSDate?
    dynamic var time = ""
    dynamic var name = ""
    //dynamic var reminderDescription = ""
    dynamic var img: NSData?
    //dynamic var notification: UILocalNotification?
    
    
}