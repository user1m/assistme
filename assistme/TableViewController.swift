//
//  TableViewController.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import UIKit
import WatchConnectivity
import PKHUD

class TableViewController: UITableViewController {
  
  var session:WCSession!
  var botList:[String : String] = ["Pizza Bot" : "Pizza bot here to help fulfill all your cheesey desires.",
                                   "Travel Bot" : "Travel bot here to help explore new places in the world.",
                                   "Shopper Bot" : "Shop til you drop.",
                                   "Fashion Bot" : "Learn about the latest fashion trends from me. \n Shopper and I are best friends",
                                   "Local News Bot" : "I'll fill you in on what's happening in your local area.",
                                   "Entertainment Bot" : "You want celeb gossip and entertainment industry news then I'm your bot!",
                                   "Music Bot" : "I learn your musical taste and help you explore it."]
  var id = "c257fa03-c902-43cc-b6ce-68a32d3ca651";
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    title = "Select a Bot"
    
    HUD.show(.Progress)
    
    API.getDialogs({data, error -> Void in
      if (data != nil) {
        API.sharedInstance.dialogs.appendContentsOf(NSArray(array: data) as! [[String : String]])
        dispatch_async(dispatch_get_main_queue(), {
          HUD.flash(.Success, delay: 0.5)
//          self.tableView.reloadData()
        })
      } else {
        print("api.getData failed")
        print(error)
        dispatch_async(dispatch_get_main_queue(), {
          HUD.flash(.Error, delay: 0.5)
        })
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    if api.dialogs.count > 0 {
    //      return api.dialogs.count
    //    }
    //    return API.sharedInstance.dialogs.count
    return botList.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let intIndex = indexPath.row
    let index = botList.startIndex.advancedBy(intIndex)
    
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DialogTableViewCell
    
    cell.titleLabel.text = "\(botList.keys[index])"
    cell.descriptionLabel.text = "\(botList.values[index])"
    
    // Configure the cell...
    
    return cell
  }
  
  
  //  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  //    self.selectedDialog = api[indexPath.row]
  //  }
  /*
   // Override to support conditional editing of the table view.
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
   if editingStyle == .Delete {
   // Delete the row from the data source
   tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
   } else if editingStyle == .Insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if (segue.identifier == "chatSegue"){
      let destination = segue.destinationViewController as! ChatViewController
      destination.currentDialog = API.sharedInstance.dialogs[0]
      destination.id = self.id
//      destination.currentDialog = API.sharedInstance.dialogs[(self.tableView.indexPathForSelectedRow?.row)!]
    }
  }
}


extension TableViewController {
  
}
