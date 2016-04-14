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
  static var data:[[String : String]]! = []
  
  @IBOutlet var chatTable: WKInterfaceTable!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    if context != nil {
      setTitle("< "+(context as? String)!)
    }
    
    setupWC()
  }
  
  func setupTable() {
    var currentRow = ChatRow()
    
    if ChatInterfaceController.data.count != 0 {
      chatTable.setNumberOfRows(ChatInterfaceController.data.count, withRowType: "chatRow")
      
      for rowNumber in 0..<self.chatTable.numberOfRows{
        
        currentRow = self.chatTable.rowControllerAtIndex(rowNumber) as! ChatRow
        //returns generic obj then cast as MovieRowController
        currentRow.setRow(ChatInterfaceController.data[rowNumber])
      }
    } else {
      chatTable.setNumberOfRows(1, withRowType: "chatRow")
      currentRow = self.chatTable.rowControllerAtIndex(0) as! ChatRow
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
      do {
        if (session.reachable) {
          session.sendMessage(["status":"initialiing"], replyHandler: nil, errorHandler: nil)
        }
      }
    }
  }
  
  // mARK: Messaging
  func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
    print(message)
    if (message["data"] != nil) {
      ChatInterfaceController.data.insert((message["data"] as! [String : String]), atIndex: 0)
      setupTable()
    }
  }
  
}
