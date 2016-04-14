//
//  InterfaceController.swift
//  assistme WatchKit Extension
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  
  @IBOutlet var chatTable: WKInterfaceTable!
  
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    // Configure interface objects here.
    
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
  
  /*
   Responding to Table Taps - called automatically if any table onscreen is tapped
   */
  override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
    
  }
  
  override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
    if (segueIdentifier == "chat") {
      let index = API.botList.startIndex.advancedBy(rowIndex)
      return API.botList.keys[index]
    }
    return nil
  }
  
  
  func setupTable() {
    chatTable.setNumberOfRows(API.botList.count, withRowType: "listRow")
    
    for rowNumber in 0..<self.chatTable.numberOfRows{
      
      //returns generic obj then cast as RowController
      let currentRow = self.chatTable.rowControllerAtIndex(rowNumber) as! ListRow
      let index = API.botList.startIndex.advancedBy(rowNumber)
      currentRow.chatBotLbl.setText(API.botList.keys[index])
//      currentRow.chatBotIcon.setImageNamed("\(API.botList.values[index][1])")
    }
  }
  
}
