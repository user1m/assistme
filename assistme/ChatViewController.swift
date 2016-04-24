//
//  ChatViewController.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import WatchConnectivity
import PKHUD

class ChatViewController: JSQMessagesViewController{
  
  //    var currentDialog:[String:String] = [:]
  var id:String! = ""
  var botName: String! = ""
  var client_id:Int = 0, conversation_id:Int = 0
  var session:WCSession = WCSession.defaultSession()
  
  let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
  let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
  var messages = [JSQMessage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setupWC()
    
    //print(self.id)
    
    title =  "\(botName)"
    
    HUD.show(.Progress)
    
    self.getConvoData("id=\(self.id)")
    self.setup()
    
    //    self.addDemoMessages()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func setupIds(results:[String: AnyObject]) {
    self.client_id = results["conversation"]!["client_id"] as! Int
    self.conversation_id = results["conversation"]!["conversation_id"] as! Int
  }
  
  func getConvoData(params:String? = nil){
    
    //initate convo
    API.getConversation(params,completionHandler: {data, error -> Void in
      if (data != nil) {
        let results = NSDictionary(dictionary: data) as! [String : AnyObject]
        let responses = results["conversation"]!["response"] as! Array<String>
        //        if ( results["error"] == nil) {
        
        if self.client_id == 0 || self.conversation_id == 0 {
          self.setupIds(results)
        }
        
        API.sharedInstance.conversations.append(results)
        for response in responses {
          if !response.isEmpty {
            // TODO: make dynamic
            self.addMessage(JSQMessage(senderId: "chatbot", senderDisplayName: "\(self.botName)", date: NSDate(), text: response))
            self.updateWatch(["bot":response])
          }
        }
        
        //modify UI from main thread
        dispatch_async(dispatch_get_main_queue(), {
          self.reloadMessagesView()
          HUD.flash(.Success, delay: 0.5)
        })
      } else {
        dispatch_async(dispatch_get_main_queue(), {
          HUD.flash(.Error, delay: 0.5)
        })
        print("api.getData failed")
        print(error)
      }
    })
    
  }
  
  func reloadMessagesView() {
    self.collectionView?.reloadData()
    
    // Message Watch
    //    self.updateWatch()
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

extension ChatViewController {
//  func addDemoMessages() {
//    for i in 1...10 {
//      let sender = (i%2 == 0) ? "Server" : self.senderId
//      let messageContent = "Message nr. \(i)"
//      let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
//      self.messages += [message]
//    }
//    self.reloadMessagesView()
//  }
  
  func setup() {
    self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
    self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
  }
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.messages.count
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    let data = self.messages[indexPath.row]
    return data
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
    self.messages.removeAtIndex(indexPath.row)
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    let data = messages[indexPath.row]
    switch(data.senderId) {
    case self.senderId:
      return self.outgoingBubble
    default:
      return self.incomingBubble
    }
  }
  
  override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  func addMessage(message:JSQMessage) {
    if (message.senderId == self.senderId) {
      API.sharedInstance.savedInputs.append(["user":message.text])
    } else {
      API.sharedInstance.savedInputs.append(["bot":message.text])
    }
    self.messages += [message]
  }
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    addMessage(JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text))
    
    var params = ""
    if client_id != 0 && conversation_id != 0 {
      params = "id=\(self.id)&input=\(text)&client_id=\(self.client_id)&conversation_id=\(self.conversation_id)"
    }
    
    updateWatch(["user":text])
    
    if( classify(text) ) {
      API.classify({reply -> Void in
        self.addMessage(JSQMessage(senderId: "chatbot", senderDisplayName: "\(self.botName)", date: NSDate(), text: reply))
        self.updateWatch(["bot":reply])
        
        //modify UI from main thread
        dispatch_async(dispatch_get_main_queue(), {
          self.reloadMessagesView()
          HUD.flash(.Success, delay: 0.5)
        })
      })
    } else {
      self.getConvoData(params)
    }
    self.finishSendingMessage()
  }
  
  override func didPressAccessoryButton(sender: UIButton!) {
    
  }
  
  func classify(text:String!) -> Bool {
    return botName != "Pizza Bot" && text.lowercaseString.rangeOfString("pizza") != nil
  }
  
}


extension ChatViewController: WCSessionDelegate {
  
  // MARK: Messaging
  func updateWatch(data:[String : String]!) {
    if (WCSession.defaultSession().reachable) {
      session.sendMessage(["data" : data], replyHandler: nil, errorHandler: nil)
    }
  }
  
  func setupWC() {
    if(WCSession.isSupported()){
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
  
  func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
    print(message)
  }
  
  
  
}

