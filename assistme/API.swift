//
//  API.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
import Alamofire

public class API {
  
  static let baseApi = "http://convoapi.azurewebsites.net/"
  static let convo = "conversation", dialog = "dialogs"
  static let session = NSURLSession.sharedSession()
  
  // MARK: Singleton
  //singleton
  //  public static var sharedInstance: API? = API()
  public static let sharedInstance: API = API()
  //empty private constructor
  private init() {
    savedInputs = []
    dialogs = []
    conversations = []
  }
  
  public var savedInputs:[[String : String]]!
  public var dialogs:[[String:String]]!
  public var conversations:[[String:AnyObject]]!
  
  static func getDialogs(completionHandler: ((NSArray!, NSError!) -> Void)!) -> Void
  {
    
    Alamofire.request(.GET, "\(baseApi)\(dialog)")
      .responseJSON { response in
        if let JSON = response.result.value {
          //          print(JSON["reply"])
          return completionHandler(JSON as! NSArray , nil)
        }
    }
  }
  
  // Setup the session to make REST GET call. (HTTPS vs HTTP)
  static func getConversation(params:String?, completionHandler: (([String:AnyObject]!, NSError!) -> Void)!) -> Void
  {
    Alamofire.request(.GET, (params != nil && !params!.isEmpty) ? "\(baseApi)\(convo)?\(params!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)" : "\(baseApi)\(convo)")
      .responseJSON { response in
        if let JSON = response.result.value {
          //          print(JSON["reply"])
          return completionHandler(JSON as! [String : AnyObject], nil)
        }
    }
  }
  
  //  static func classify( completionHandler: (([String:AnyObject]!, NSError!) -> Void)!) -> Void
  static func classify( handler: ((reply: String!) -> Void)!) -> Void
  {
    Alamofire.request(.GET, "\(API.baseApi)classify")
      .responseJSON { response in
        if let JSON = response.result.value {
          //          print(JSON["reply"])
          return handler(reply: JSON["reply"] as! String)
        }
    }
  }
}