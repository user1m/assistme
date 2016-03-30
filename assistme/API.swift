//
//  API.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import Foundation
import UIKit


public class API: NSObject {
  
  //singleton
  static let sharedInstance = API()
  
  //  let dialog:String = "dialog"
  //  let conversation:String = "conversation"
  let baseApi = "http://convoapi.azurewebsites.net/"
  let convo = "conversation", dialog = "dialogs"
  var client_id:String?, conversation_id:String?
  let session = NSURLSession.sharedSession()
  var dialogs:[[String:String]] = []
  var conversations:[[String:AnyObject]] = []
  
  //  init(){
  //  }
  
  static func getSingleton() -> API {
    return self.sharedInstance
  }
  
  
  func getDialogs(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void
  {
    let url = NSURL(string: "\(baseApi)\(dialog)")!
    
    session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      
      guard let realResponse = response as? NSHTTPURLResponse where
        realResponse.statusCode == 200 else {
          print("Not a 200 response")
          return
      }
      
      // Read the JSON
      do {
        if let result = NSString(data:data!, encoding: NSUTF8StringEncoding) {
          print(result)
          
          // Parse the JSON to get the data
          let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
          //          self.performSelectorOnMainThread(#selector(API.gotData(_:)), withObject: jsonDictionary, waitUntilDone: true)
          return completionHandler(json, nil)
        }
      } catch {
        error
        //        print("Error: Failed to getdialogs ")
      }
    }).resume()
  }
  
  // Setup the session to make REST GET call. (HTTPS vs HTTP)
  func getConversation(params:String? = nil, completionHandler: (([String:AnyObject]!, NSError!) -> Void)!) -> Void
  {
    var url = NSURL(string: "\(baseApi)\(convo)")!
    if (params != nil && !params!.isEmpty)
    {
       url = NSURL(string: "\(baseApi)\(convo)?\(params)")!
    }
    
    session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      
      guard let realResponse = response as? NSHTTPURLResponse where
        realResponse.statusCode == 200 else {
          print("Not a 200 response")
          return
      }
      
      // Read the JSON
      do {
        if let result = NSString(data:data!, encoding: NSUTF8StringEncoding) {
          print(result)
          
          // Parse the JSON to get the data
          let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
          return completionHandler(json, nil)
        }
      } catch {
        error
        //        print("Error: Failed to get conversation ")
      }
    }).resume()
  }
  
  // Setup the session to make REST POST call
  //  func postConversation(endpoint:String, input:String) {
  //    let url = NSURL(string: endpoint)!
  //    //    var postParams:[String:String] = [:]
  //    var bodyStr:String = ""
  //    // Create the request
  //    let request = NSMutableURLRequest(URL: url)
  //
  //    if let client_id:String = self.client_id! , conversation_id:String = self.conversation_id!{
  //      //       postParams = ["input": input, "client_id": client_id, "conversation_id":conversation_id]
  //      bodyStr = "input=\(input),client_id=\(client_id),converstation_id=\(conversation_id)"
  //    }
  //
  //    request.HTTPMethod = "POST"
  //    //    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
  //    request.HTTPBody = bodyStr.dataUsingEncoding(NSUTF8StringEncoding)
  //    request.setValue("application/json", forHTTPHeaderField: "Accept")
  //    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
  //
  //    //    do {
  //    ////      request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
  //    ////      print(postParams)
  //    //    } catch {
  //    //      print("bad things happened")
  //    //    }
  //
  //    // Make the POST call and handle it in a completion handler
  //    session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
  //      // Make sure we get an OK response
  //      guard let realResponse = response as? NSHTTPURLResponse where
  //        realResponse.statusCode == 200 else {
  //          print("Not a 200 response")
  //          return
  //      }
  //
  //      // Read the JSON
  //      if let result = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
  //        // Print what we got from the call
  //        print("POST: " + result)
  //        //        self.performSelectorOnMainThread("updatePostLabel:", withObject: postString, waitUntilDone: false)
  //      }
  //
  //    }).resume()
  //
  //  }
  
  
}