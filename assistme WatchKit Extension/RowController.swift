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
  @IBOutlet var lblBackground: WKInterfaceGroup!
  
  func setRow(data:[String : String]) {
    
    //user
    if (data["user"] != nil) {
      self.lblBackground.setBackgroundColor(UIColor.lightGrayColor())
      self.chatLabel.setTextColor(UIColor.whiteColor())
      self.chatLabel.setText(data["user"])
    } else {
      //bot
      self.lblBackground.setBackgroundColor(UIColor.blueColor())
      self.chatLabel.setTextColor(UIColor.whiteColor())
      self.chatLabel.setText(data["bot"])
    }
  }
  
  func setUpNoData() {
    self.chatLabel.setText("No chat data yet")
  }
}
