//
//  API.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import Foundation


public class API {
  
  //singleton
  static let sharedInstance = API()
  
  //  let dialog:String = "dialog"
  //  let conversation:String = "conversation"
  let baseApi = "http://convoapp.azurewebsites.net/"
  var client_id:String?, conversation_id:String?
  let session = NSURLSession.sharedSession()
  
  init(){
  }
  
  static func getSingleton() -> API {
    return self.sharedInstance
  }
  
  // Setup the session to make REST GET call. (HTTPS vs HTTP)
  func getQuery(endpoint:String, dialog_id:String? = nil)
  {
    let url = NSURL(string: endpoint)!
    
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
        if let result = NSString(data:data!, encoding: NSUTF8StringEncoding) {
          // Print what we got from the call
          print(result)
          
          // Parse the JSON to get the data
          let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
          self.client_id = jsonDictionary["client_id"] as? String
          self.conversation_id = jsonDictionary["conversation_id"] as? String
          
          // Update the label
          //          self.performSelectorOnMainThread(#selector(ChatViewController.updateIPLabel(_:)), withObject: origin, waitUntilDone: false)
        }
      } catch {
        print("bad things happened")
      }
    }).resume()
  }
  
  // Setup the session to make REST POST call
  func postConversation(endpoint:String, input:String) {
    let url = NSURL(string: endpoint)!
    //    var postParams:[String:String] = [:]
    var bodyStr:String = ""
    // Create the request
    let request = NSMutableURLRequest(URL: url)
    
    if let client_id:String = self.client_id! , conversation_id:String = self.conversation_id!{
      //       postParams = ["input": input, "client_id": client_id, "conversation_id":conversation_id]
      bodyStr = "input=\(input),client_id=\(client_id),converstation_id=\(conversation_id)"
    }
    
    request.HTTPMethod = "POST"
    //    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    //    do {
    ////      request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
    ////      print(postParams)
    //    } catch {
    //      print("bad things happened")
    //    }
    
    // Make the POST call and handle it in a completion handler
    session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      // Make sure we get an OK response
      guard let realResponse = response as? NSHTTPURLResponse where
        realResponse.statusCode == 200 else {
          print("Not a 200 response")
          return
      }
      
      // Read the JSON
      if let result = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
        // Print what we got from the call
        print("POST: " + result)
        //        self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
      }
      
    }).resume()
    
  }
  
  
}