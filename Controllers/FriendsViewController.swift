//
//  FriendsViewController.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/13/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import Parse
class FriendsViewController: UIViewController{
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    var users: [PFUser]?
//    
//    var followingUsers: [PFUser]?{
//        didSet{
//            tableView.reloadData()
//        }
//    }
//    var query: PFQuery? {
//        didSet {
//            oldValue?.cancel()
//        }
//    }
//    enum State {
//        case DefaultMode
//        case SearchMode
//    }
//
//    // whenever the state changes, perform one of the two queries and update the list
//    var state: State = .DefaultMode {
//        didSet {
//            switch (state) {
//            case .DefaultMode:
//                query = ParseHelper.allUsers(updateList)
//                
//            case .SearchMode:
//                let searchText = searchBar?.text ?? ""
//                query = ParseHelper.searchUsers(searchText, completionBlock:updateList)
//            }
//        }
//    }
//    func updateList(results: [PFObject]?, error: NSError?) {
//        if let error = error {
//            ErrorHandling.defaultErrorHandler(error)
//        }
//        
//        self.users = results as? [PFUser] ?? []
//        self.tableView.reloadData()
//        
//    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        state = .DefaultMode
//        
//        // fill the cache of a user's followees
//        ParseHelper.getFollowingUsersForUser(PFUser.currentUser()!) { (results: [PFObject]?, error: NSError?) -> Void in
//            if let error = error {
//                ErrorHandling.defaultErrorHandler(error)
//            }
//            
//            let relations = results ?? []
//            // use map to extract the User from a Follow object
//            self.followingUsers = relations.map {
//                $0.objectForKey(ParseHelper.ParseFollowToUser) as! PFUser
//            }
//            
//        }
    }


    
    
}





// MARK: TableView Data Source

//extension FriendsViewController: UITableViewDataSource {
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.users?.count ?? 0
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! FriendSearchTableViewCell
//        
//        let user = users![indexPath.row]
//        cell.user = user
//        
//        if let followingUsers = followingUsers {
//            // check if current user is already following displayed user
//            // change button appereance based on result
//            cell.canFollow = !followingUsers.contains(user)
//        }
//        
//        cell.delegate = self
//        
//        return cell
//    }
//}
//
//// MARK: Searchbar Delegate
//extension FriendsViewController: UISearchBarDelegate {
//    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//        state = .SearchMode
//    }
//    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        searchBar.text = ""
//        searchBar.setShowsCancelButton(false, animated: true)
//        state = .DefaultMode
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        ParseHelper.searchUsers(searchText, completionBlock:updateList)
//    }
//    
//}
//
//// MARK: Cell Protocol
//extension FriendsViewController: FriendSearchTableViewCellDelegate {
//    
//    func cell(cell: FriendSearchTableViewCell, didSelectFollowUser user: PFUser) {
//        ParseHelper.addFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
//        // update local cache
//        followingUsers?.append(user)
//    }
//    
//    func cell(cell: FriendSearchTableViewCell, didSelectUnfollowUser user: PFUser) {
//        if let followingUsers = followingUsers {
//            ParseHelper.removeFollowRelationshipFromUser(PFUser.currentUser()!, toUser: user)
//            // update local cache
//            self.followingUsers = followingUsers.filter({$0 != user})
//        }
//    }
//    
//}