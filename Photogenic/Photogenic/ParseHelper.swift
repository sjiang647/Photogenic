//
//  ParseHelper.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/14/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

//import Foundation
//import Parse
//
//class ParseHelper{
//    static let ParseFollowClass       = "Follow"
//    static let ParseFollowFromUser    = "fromUser"
//    static let ParseFollowToUser      = "toUser"
//    
//    static let ParsePostUser          = "user"
//    static let ParsePostCreatedAt     = "createdAt"
//
//    static let ParseUserUsername      = "username"
//
//    static func timelineRequestForCurrentUser(range: Range<Int>, completionBlock: PFQueryArrayResultBlock) {
//        let followingQuery = PFQuery(className: ParseFollowClass)
//        followingQuery.whereKey(ParseFollowFromUser, equalTo:PFUser.currentUser()!)
//        
//        let postsFromFollowedUsers = Reminder.query()
//        postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
//        
//        let postsFromThisUser = Reminder.query()
//        postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
//        
//        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
//        query.includeKey(ParsePostUser)
//        query.orderByDescending(ParsePostCreatedAt)
//        
//        // 2
//        query.skip = range.startIndex
//        // 3
//        query.limit = range.endIndex - range.startIndex
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
//    static func getFollowingUsersForUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
//        let query = PFQuery(className: ParseFollowClass)
//        
//        query.whereKey(ParseFollowFromUser, equalTo:user)
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//    }
//    static func addFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
//        let followObject = PFObject(className: ParseFollowClass)
//        followObject.setObject(user, forKey: ParseFollowFromUser)
//        followObject.setObject(toUser, forKey: ParseFollowToUser)
//        
//        followObject.saveInBackgroundWithBlock(nil)
//    }
//    
//    /**
//     Deletes a follow relationship between two users.
//     
//     :param: user    The user that is following
//     :param: toUser  The user that is being followed
//     */
//    static func removeFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
//        let query = PFQuery(className: ParseFollowClass)
//        query.whereKey(ParseFollowFromUser, equalTo:user)
//        query.whereKey(ParseFollowToUser, equalTo: toUser)
//        
//        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
//            
//            let results = results ?? []
//            
//            for follow in results {
//                follow.deleteInBackgroundWithBlock(nil)
//            }
//        }
//    }
//    
//    static func allUsers(completionBlock: PFQueryArrayResultBlock) -> PFQuery {
//        let query = PFUser.query()!
//        // exclude the current user
//        query.whereKey(ParseHelper.ParseUserUsername,
//                       notEqualTo: PFUser.currentUser()!.username!)
//        query.orderByAscending(ParseHelper.ParseUserUsername)
//        query.limit = 20
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//        
//        return query
//    }
//    static func searchUsers(searchText: String, completionBlock: PFQueryArrayResultBlock) -> PFQuery {
//        /*
//         NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
//         Regex can be slow on large datasets. For large amount of data it's better to store
//         lowercased username in a separate column and perform a regular string compare.
//         */
//        let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
//                                             matchesRegex: searchText, modifiers: "i")
//        
//        query.whereKey(ParseHelper.ParseUserUsername,
//                       notEqualTo: PFUser.currentUser()!.username!)
//        
//        query.orderByAscending(ParseHelper.ParseUserUsername)
//        query.limit = 10
//        
//        query.findObjectsInBackgroundWithBlock(completionBlock)
//        
//        return query
//    }
//}
//extension PFObject {
//    
//    public override func isEqual(object: AnyObject?) -> Bool {
//        if (object as? PFObject)?.objectId == self.objectId {
//            return true
//        } else {
//            return super.isEqual(object)
//        }
//    }
//    
//} 
//
//
