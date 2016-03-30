//
//  ChatViewController.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import UIKit
import JSQMessagesViewController


class ChatViewController: JSQMessagesViewController {
  
  
  let api = API.getSingleton()
  var currentDialog:[String:String] = [:]
  var client_id:Int = 0, conversation_id:Int = 0
  
  let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
  let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
  var messages = [JSQMessage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    title =  "Pizza Chat Bot"
    
    //    self.getConvoData()
    self.setup()
    self.addDemoMessages()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func setupIds(results:[String: AnyObject]) {
    self.client_id = results["conversation"]!["client_id"] as! Int
    self.conversation_id = results["conversation"]!["conversation_id"] as! Int
  }
  
  func updateConverationView(responses:NSArray){
    for resp in responses{
      if let resp = resp as? String{
        //        self.chatInput += "\(resp))\n"
      }
    }
  }
  
  
  func getConvoData(params:String? = nil){
    //initate convo
    api.getConversation(params,completionHandler: {data, error -> Void in
      if (data != nil) {
        let results = NSDictionary(dictionary: data) as! [String : AnyObject]
        let responses = results["conversation"]!["response"] as! NSArray
        
        self.setupIds(results)
        
        self.api.conversations.append(results)
        self.updateConverationView(responses)
        
      } else {
        print("api.getData failed")
        print(error)
      }
    })
    
  }
  
  @IBAction func sendChat() {
    var params = ""
    //    if client_id != 0 && conversation_id != 0 {
    //      params = "input=\(self.chatInput.text)&client_id=\(self.client_id)&conversation_id=\(self.conversation_id)"
    //    }
    
    self.getConvoData(params)
  }
  
  func reloadMessagesView() {
    self.collectionView?.reloadData()
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
  
  override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    self.messages += [message]
    self.finishSendingMessage()
  }
  
  override func didPressAccessoryButton(sender: UIButton!) {
    
  }
}


