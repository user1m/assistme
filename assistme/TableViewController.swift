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
  //  let id = "c257fa03-c902-43cc-b6ce-68a32d3ca651";
  
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
    
//    API.getDialogs({data, error -> Void in
//      if (data != nil) {
//        API.sharedInstance.dialogs.appendContentsOf(NSArray(array: data) as! [[String : String]])
//        dispatch_async(dispatch_get_main_queue(), {
//          HUD.flash(.Success, delay: 0.5)
//          //          self.tableView.reloadData()
//        })
//      } else {
//        print("api.getData failed")
//        print(error)
//        dispatch_async(dispatch_get_main_queue(), {
//          HUD.flash(.Error, delay: 0.5)
//        })
//      }
//    })
    
    HUD.flash(.Success, delay: 0.5)
    
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
    return API.botList.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let intIndex = indexPath.row
    let index = API.botList.startIndex.advancedBy(intIndex)
    
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DialogTableViewCell
    
    cell.titleLabel.text = "\(API.botList.keys[index])"
    cell.descriptionLabel.text = "\(API.botList.values[index][0])"
    cell.botImage.image = UIImage(named: "\(API.botList.values[index][1])")
    
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
      let index = API.botList.startIndex.advancedBy((self.tableView.indexPathForSelectedRow?.row)!)
      let botName = API.botList.keys[index]
      destination.bot = botName
      if (botName == "Shopper Bot") {
        destination.id = "48dbb947-f2d3-4d9d-b7ca-aee86c0a5c23" //API.sharedInstance.dialogs[1]["dialog_id"]
      } else {
        destination.id = "736546c7-bea9-441f-8a53-07a5502cae3b"
      }
      //      if (API.sharedInstance.dialogs.count > 0) {
      //        destination.currentDialog = API.sharedInstance.dialogs[0]
      //      }
      //      else {
      //        destination.id = self.id
      //      }
      //      destination.currentDialog = API.sharedInstance.dialogs[(self.tableView.indexPathForSelectedRow?.row)!]
    }
  }
}


extension TableViewController {
  
}
