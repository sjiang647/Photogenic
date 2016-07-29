//
//  Clip.swift
//  Photogenic
//
//  Created by Steve Jiang on 7/27/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Clip: Object{
    dynamic var img: UIImage?
    dynamic var desc: String?
}