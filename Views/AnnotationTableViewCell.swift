//
//  AnnotationTableViewCell.swift
//  Photogenic
//
//  Created by Steve Jiang on 8/5/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//



import Foundation
import UIKit

import MGSwipeTableCell
class AnnotationTableViewCell: MGSwipeTableCell{
    var annotation: Annotation?
    
    @IBOutlet weak var num: UILabel!
    

    @IBOutlet weak var annotationText: UILabel!
}