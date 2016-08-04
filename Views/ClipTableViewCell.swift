//
//  ClipTableViewCell.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/28/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MGSwipeTableCell
class ClipTableViewCell: MGSwipeTableCell{
    var annotation: Annotation?
    
    @IBOutlet weak var number: UILabel!
    
    
    @IBOutlet weak var label: UILabel!
}