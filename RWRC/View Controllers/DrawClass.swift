//
//  DrawClass.swift
//  RWRC
//
//  Created by Krisha Jivani on 5/20/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

struct Draw {
  let toPointX: NSNumber
  let toPointY: NSNumber
  let fromPointX: NSNumber
  let fromPointY: NSNumber
  let color: NSNumber
  let key: String
  let ref: DatabaseReference?
  
  init(fromPointX: NSNumber, fromPointY: NSNumber, toPointX: NSNumber, toPointY: NSNumber, color: NSNumber, key: String = "") {
    self.key = key
    self.fromPointX = fromPointX
    self.fromPointY = fromPointY
    self.toPointX = toPointX
    self.toPointY = toPointY
    self.color = color
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    self.key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    self.fromPointX = snapshotValue["fromPointX"] as! NSNumber
    self.fromPointY = snapshotValue["fromPointY"] as! NSNumber
    self.toPointX = snapshotValue["toPointX"] as! NSNumber
    self.toPointY = snapshotValue["toPointY"] as! NSNumber
    self.color = snapshotValue["color"] as! NSNumber
    self.ref = snapshot.ref
  }
  
  func toAnyObject() -> Any {
    return[
      "fromPointX": fromPointX,
      "fromPointY": fromPointY,
      "toPointX": toPointX,
      "toPointY": toPointY,
      "color" : color
    ]
  }
}
