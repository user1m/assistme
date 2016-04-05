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


class ChatViewController: JSQMessagesViewController{
  
  
  var currentDialog:[String:String] = [:]
  var client_id:Int = 0, conversation_id:Int = 0
  var session:WCSession = WCSession.defaultSession()
  
  let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
  let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
  var messages = [JSQMessage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    title =  "Pizza Chat Bot"
    
    self.getConvoData()
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
        
        if self.client_id == 0 || self.conversation_id == 0 {
          self.setupIds(results)
        }
        
        API.conversations.append(results)
        for response in responses {
          if !response.isEmpty {
            // TODO: make dynamic
            self.addMessage(JSQMessage(senderId: "chatbot", senderDisplayName: "Pizza Chat Bot", date: NSDate(), text: response))
          }
        }

        //modify UI from main thread
        dispatch_async(dispatch_get_main_queue(), {
          self.reloadMessagesView()
        })
        
      } else {
        print("api.getData failed")
        print(error)
      }
    })
    
  }
  
  func reloadMessagesView() {
    self.collectionView?.reloadData()
    
    // Message Watch
    self.updateWatch()
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
  func addDemoMessages() {
    for i in 1...10 {
      let sender = (i%2 == 0) ? "Server" : self.senderId
      let messageContent = "Message nr. \(i)"
      let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
      self.messages += [message]
    }
    self.reloadMessagesView()
  }
  
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
      API.savedInputs.append(["sender":"user", "message":message.text])
    } else {
      API.savedInputs.append(["sender":"bot", "message":message.text])
    }
    self.messages += [message]
  }
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    addMessage(JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text))
    
    var params = ""
    if client_id != 0 && conversation_id != 0 {
      params = "input=\(text)&client_id=\(self.client_id)&conversation_id=\(self.conversation_id)"
    }
    self.getConvoData(params)
    
    self.finishSendingMessage()
  }
  
  override func didPressAccessoryButton(sender: UIButton!) {
    
  }
}


extension ChatViewController {
  
  // MARK: Messaging
  func updateWatch() {
    if (WCSession.defaultSession().reachable) {
      WCSession.defaultSession().sendMessage(["new data":true], replyHandler: nil, errorHandler: nil)
    }
  }

}

