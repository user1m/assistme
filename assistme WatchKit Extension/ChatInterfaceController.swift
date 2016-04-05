//
//  ChatInterfaceController.swift
//  assistme
//
//  Created by Claudius Mbemba on 4/2/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ChatInterfaceController: WKInterfaceController {
  
  var session: WCSession!
  
  @IBOutlet var chatTable: WKInterfaceTable!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    setupWC()
  }
  
  func setupTable() {
    var currentRow = RowController()
    
    if API.savedInputs.count != 0 {
      chatTable.setNumberOfRows(API.savedInputs.count, withRowType: "chatRow")
      
      for rowNumber in 0..<self.chatTable.numberOfRows{
        
        currentRow = self.chatTable.rowControllerAtIndex(rowNumber) as! RowController
        //returns generic obj then cast as MovieRowController
        currentRow.setRow(API.savedInputs[rowNumber])
      }
    } else {
      chatTable.setNumberOfRows(1, withRowType: "chatRow")
      currentRow = self.chatTable.rowControllerAtIndex(0) as! RowController
      currentRow.setUpNoData()
    }
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    setupTable()
    
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
}


extension ChatInterfaceController: WCSessionDelegate {
  
  func setupWC() {
    if (WCSession.isSupported()) {
      session = WCSession.defaultSession()
      session.delegate = self
      session.activateSession()
    }
  }
  
  // mARK: Messaging
  func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
    print(message)
    if (message["new data"] != nil) {
      setupTable()
    }
  }
  
}
