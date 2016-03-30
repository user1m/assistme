//
//  TableViewController.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  
  let api = API.getSingleton()
  //  let api = [["name":"pizza_sample_cm",
  //    "dialog_id":"c257fa03-c902-43cc-b6ce-68a32d3ca651"],
  //             ["name":"pizza_sample_cm",
  //              "dialog_id":"c257fa03-c902-43cc-b6ce-68a32d3ca651"],
  //             ["name":"pizza_sample_cm",
  //              "dialog_id":"c257fa03-c902-43cc-b6ce-68a32d3ca651"]]
  //  var selectedDialog:[String:String] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    title = "Pick a Bot"
    
    api.getDialogs({data, error -> Void in
      if (data != nil) {
        self.api.dialogs = NSArray(array: data) as! [[String : String]]
        self.tableView.reloadData()
      } else {
        print("api.getData failed")
        print(error)
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
    return api.dialogs.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DialogTableViewCell
    
    cell.titleLabel.text = "Chat Bot: \(api.dialogs[indexPath.row]["name"]!)"
    cell.descriptionLabel.text = "ID: \(api.dialogs[indexPath.row]["dialog_id"]!)"
    
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
      destination.currentDialog = api.dialogs[(self.tableView.indexPathForSelectedRow?.row)!] as! [String : String]
    }
  }
  
  
}
