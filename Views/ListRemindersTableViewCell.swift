//
//  ListRemindersTableViewCell.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/12/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit

import MGSwipeTableCell
class ListRemindersTableViewCell: MGSwipeTableCell{
    @IBOutlet var backgroundImage: UIImageView!
    
   
    @IBOutlet var cellName: UILabel!
    @IBOutlet var cellTime: UILabel!
    
    @IBOutlet var cellDescription: UILabel!
    
   
    
}