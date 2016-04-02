//
//  RowController.swift
//  assistme
//
//  Created by Claudius Mbemba on 4/2/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import WatchKit

class RowController: NSObject {
  
  @IBOutlet var chatLabel: WKInterfaceLabel!
  
  func setRow(data:Dictionary<String, String>) {
    switch data["sender"]! {
    case "user":
      self.chatLabel.setTextColor(UIColor.blueColor())
      self.chatLabel.setText(data["message"])
    case "bot":
      self.chatLabel.setTextColor(UIColor.whiteColor())
      self.chatLabel.setText(data["message"])
    default:
      break
    }
  }
  
  func setUpNoData() {
    self.chatLabel.setText("No chat data yet")
  }
}
