//
//  FriendSearchTableViewCell.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/14/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import Parse
//protocol FriendSearchTableViewCellDelegate: class {
//    func cell(cell: FriendSearchTableViewCell, didSelectFollowUser user: PFUser)
//    func cell(cell: FriendSearchTableViewCell, didSelectUnfollowUser user: PFUser)
//}
class FriendSearchTableViewCell: UITableViewCell{
    
    @IBOutlet var followButton: UIButton!
    @IBOutlet var name: UILabel!
//    weak var delegate: FriendSearchTableViewCellDelegate?

    @IBAction func followButtonTapped(sender: AnyObject) {
//        if let canFollow = canFollow where canFollow == true {
//            delegate?.cell(self, didSelectFollowUser: user!)
//            self.canFollow = false
//        } else {
//            delegate?.cell(self, didSelectUnfollowUser: user!)
//            self.canFollow = true
//        }
    }
    var user: PFUser? {
        didSet {
            name.text = user?.username
        }
    }
    
    var canFollow: Bool? = true {
        didSet {
            /*
             Change the state of the follow button based on whether or not
             it is possible to follow a user.
             */
            if let canFollow = canFollow {
                followButton.selected = !canFollow
            }
        }
    }

}