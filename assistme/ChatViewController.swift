//
//  ChatViewController.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
  
  @IBOutlet weak var greetLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  @IBAction func fetchData(sender: AnyObject) {
    
    // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
    let postEndpoint: String = "https://httpbin.org/ip"
    let session = NSURLSession.sharedSession()
    let url = NSURL(string: postEndpoint)!
    
    // Make the POST call and handle it in a completion handler
    session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      // Make sure we get an OK response
      guard let realResponse = response as? NSHTTPURLResponse where
        realResponse.statusCode == 200 else {
          print("Not a 200 response")
          return
      }
      
      // Read the JSON
      do {
        if let ipString = NSString(data:data!, encoding: NSUTF8StringEncoding) {
          // Print what we got from the call
          print(ipString)
          
          // Parse the JSON to get the IP
          let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
          let origin = jsonDictionary["origin"] as! String
          
          // Update the label
          self.performSelectorOnMainThread(#selector(ChatViewController.updateIPLabel(_:)), withObject: origin, waitUntilDone: false)
        }
      } catch {
        print("bad things happened")
      }
    }).resume()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateIPLabel (text: String) {
    self.contentLabel.text = "Hello" + text
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
