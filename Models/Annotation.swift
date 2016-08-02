//
//  Annotation.swift
//  Photogenic
//
//  Created by Steve Jiang on 8/1/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import CoreGraphics
class Annotation: Object{
    dynamic var coordStringFormat: String?
    dynamic var text: String?
}