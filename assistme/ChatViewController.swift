//
//  ChatViewController.swift
//  assistme
//
//  Created by Claudius Mbemba on 3/27/16.
//  Copyright © 2016 Claudius Mbemba. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
  
  @IBOutlet weak var chatView: UITextView!
  @IBOutlet weak var chatInput: UITextField!
  
  let api = API.getSingleton()
  var currentDialog:[String:String] = [:]
  var client_id:Int = 0, conversation_id:Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    title =  "Pizza Chat Bot"
    self.chatView.text = ""
    
    self.getConvoData()
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
        self.chatInput += "\(resp))\n"
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
    if client_id != 0 && conversation_id != 0 {
      params = "input=\(self.chatInput.text)&client_id=\(self.client_id)&conversation_id=\(self.conversation_id)"
    }
    
    self.getConvoData(params)
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
