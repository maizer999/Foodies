//
//  ChatViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 10/4/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseAuth
import FirebaseDatabase
import KRProgressHUD
class ChatViewController:JSQMessagesViewController{
    var messages = NSMutableArray()
    var timearray = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0))
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with:UIColor.init(red:221/255.0, green:221/255.0, blue:221/255.0, alpha: 1.0))
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childRef = FIRDatabase.database().reference().child("Chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+UserDefaults.standard.string(forKey:"aid")!)
        
       
        self.inputToolbar.contentView.textView.tintColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.inputToolbar.contentView.backgroundColor = UIColor.white
        self.inputToolbar.contentView.textView.font = UIFont(name: "Verdana", size:14)
        self.inputToolbar.contentView.rightBarButtonItem.setBackgroundImage(UIImage(named: "sendsms") as UIImage?, for:.normal)
        self.inputToolbar.contentView.rightBarButtonItem.setBackgroundImage(UIImage(named: "sendsms") as UIImage?, for:.disabled)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .normal)
        self.inputToolbar.contentView.rightBarButtonItem.setTitle("", for: .disabled)
        self.inputToolbar.contentView.textView.layer.cornerRadius = self.inputToolbar.contentView.textView.frame.size.height/2
        self.inputToolbar.contentView.textView.clipsToBounds = true
        
        self.senderId = UserDefaults.standard.string(forKey:"uid")!
        senderDisplayName = ""
        //UserDefaults.standard.string(forKey:"uid")!
       // collectionView.backgroundColor = UIColor.white
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        self.messages = []
  
      
//            let query = Constants.refs.databaseChats.child(UserDefaults.standard.string(forKey:"uid")!+"-"+UserDefaults.standard.string(forKey:"aid")!)
//        let ref = Fir.database.reference().child("").child("Live").child("Global")
        
        
//        childRef.observe(.childAdded) {(snapshot) in
//            if snapshot.childrenCount > 0 {
//                for artists in snapshot.children.allObjects as! [FIRDataSnapshot] {
            //_ = query.observe(.value, with: { [weak self] snapshot in
        Constants.refs.databaseChats.child(UserDefaults.standard.string(forKey:"uid")!+"-"+UserDefaults.standard.string(forKey:"aid")!).observe(.childAdded) { (snapshot) in
                
                    //let artistObject = artists.value as? [String: AnyObject]
                   
               
                
                  let data        = (snapshot).value as? NSDictionary
                    print(data!)
                    let id          = data!["sender_id"]
                    let name        = data!["sender_name"]
                    let text        = data!["text"]
                    let time        = data!["timestamp"]
                    let message = JSQMessage(senderId: id as! String , displayName: name as! String , text: text as! String )
                    self.timearray.add(time!)
                    self.messages.add(message!)
                    self.finishReceivingMessage()
                    
                }
                
        
            //}
            
       // }
//                    !text.isEmpty
//                {
//                    if let message = JSQMessage(senderId: id as! String, displayName: name as! String, text: text as! String)
//                    {
//                        self.timearray.add(time as! String)
//                        self.messages.add(message)
//
//                        self.finishReceivingMessage()
//                    }
//                }
//                }
//            }
        //}

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        let childRef = FIRDatabase.database().reference().child("Chat").child(UserDefaults.standard.string(forKey:"uid")!+"-"+UserDefaults.standard.string(forKey:"aid")!)
        
        childRef.observeSingleEvent(of:.value, with: { (snapshot) in
            
            
            
            if snapshot.childrenCount > 0 {
                
            }else{
                let refchat = Constants.refs.databaseChats.child(UserDefaults.standard.string(forKey:"uid")!+"-"+UserDefaults.standard.string(forKey:"aid")!)
                
                let key = refchat.childByAutoId().key
                //let key1 = refchat1.childByAutoId().key
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                let result = formatter.string(from: date)
                let message = ["sender_id":self.senderId,"receiver_id":UserDefaults.standard.string(forKey:"aid")!,"sender_name":UserDefaults.standard.string(forKey: "first_name")!+" "+UserDefaults.standard.string(forKey: "last_name")!,"text":"Hello","timestamp":result] as [String : Any]
                
                refchat.child(key).setValue(message)
                
                self.finishSendingMessage()
            }
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item] as! JSQMessageData
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return (messages[indexPath.item] as AnyObject).senderId == senderId ? outgoingBubble : incomingBubble
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return (messages[indexPath.item] as AnyObject).senderId == senderId ? nil : NSAttributedString(string:"")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return (messages[indexPath.item] as AnyObject).senderId == senderId ? 10 : 10
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
        view1.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.navigationController?.view.addSubview(view1)
            let refchat = Constants.refs.databaseChats.child(UserDefaults.standard.string(forKey:"uid")!+"-"+UserDefaults.standard.string(forKey:"aid")!)
        
            let key = refchat.childByAutoId().key
            //let key1 = refchat1.childByAutoId().key
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let result = formatter.string(from: date)
        let message = ["sender_id":self.senderId,"receiver_id":UserDefaults.standard.string(forKey:"aid")!,"sender_name":UserDefaults.standard.string(forKey: "first_name")!+" "+UserDefaults.standard.string(forKey: "last_name")!,"text":text,"timestamp":result] as [String : Any]
       
            refchat.child(key).setValue(message)
  
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.item]
        
        var isOutgoing = false
        
        if (message as AnyObject).senderId == senderId{
            isOutgoing = true
        }
        
        if isOutgoing {
            
            cell.textView.textColor = UIColor.white

        } else {
           
            cell.textView.textColor = UIColor.black

        }
        
        
       cell.cellTopLabel.font = UIFont(name: "Verdana", size:12)
    
       // cell.cellTopLabel.text =
        
        
        return cell
    }
    
    

    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        
        //let message = self.messages[indexPath.item]
        if indexPath.item == 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let str = self.timearray[indexPath.item] as? String
            print(str!)
            let myDate = dateFormatter.date(from:str!)
            
            
            return
                JSQMessagesTimestampFormatter.shared().attributedTimestamp(for:myDate)
        }
        
        if indexPath.item -  1 > 0{
            let previousMessage = self.timearray[indexPath.row-1] as? String
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myDate2 = dateFormatter1.date(from:previousMessage!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let str = self.timearray[indexPath.row] as? String
            let myDate = dateFormatter.date(from:str!)
            if  ( ( (myDate?.timeIntervalSince(myDate2!))! / 60) > 1){
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: myDate)
            }
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        if indexPath.item -  1 > 0{
            let previousMessage = self.timearray[indexPath.row-1] as? String
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let myDate2 = dateFormatter1.date(from:previousMessage!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let str = self.timearray[indexPath.row] as? String
            let myDate = dateFormatter.date(from:str!)
            if  (((myDate?.timeIntervalSince(myDate2!))! / 60) > 1){
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        view.endEditing(true)
        let view1 = UIView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:20))
        view1.backgroundColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0)
        self.navigationController?.view.addSubview(view1)
        
    }

    
}
