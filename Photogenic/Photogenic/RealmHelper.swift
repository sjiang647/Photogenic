//
//  RealmHelper.swift
//  MakeSchoolNotes
//
//  Created by Steve Jiang on 6/23/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    //static methods will go here
    
    
    
    
    static var notificationToken: NotificationToken?
    static var realm: Realm = try! Realm()
    
    static func addReminder(reminder: Reminder){
        
        try! realm.write(){
            realm.add(reminder)
        }
    }
    
    static func deleteReminder(reminder: Reminder) {
        try! realm.write() {
            realm.delete(reminder)
        }
    }
    
    static func updateReminder(reminderToBeUpdated: Reminder, newReminder: Reminder){
        try! realm.write(){
            reminderToBeUpdated.name = newReminder.name
//            reminderToBeUpdated.reminderDescription = newReminder.reminderDescription
            reminderToBeUpdated.time = newReminder.time
            reminderToBeUpdated.img = newReminder.img
          //  reminderToBeUpdated.tiem = newReminder.tiem
            reminderToBeUpdated.doot = newReminder.doot
        }
    }
    
    static func retrieveReminders() -> Results<Reminder>{
        return realm.objects(Reminder).sorted("time", ascending: false)
    }
}