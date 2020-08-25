//
//  ChatViewController.swift
//  POD
//
//  Created by Apple on 03/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ChatViewController: UIViewController {
    
    @IBOutlet var tblChat:UITableView!
    @IBOutlet var txtChatMsg:UITextField!
    public var dicObj:[String:AnyObject]!
    public let refreshControl = UIRefreshControl()
    var refreshTimer:Timer?
    let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.KeyBoardNotificationObserver()
        self.tblChat.estimatedRowHeight = 60;
        self.tblChat.rowHeight = UITableView.automaticDimension
        if let Id = userInfo!["Id"]{
            ChatController.GetChatMessage(vc: self, senderID: (Id as! String), receiverID: (dicObj["CustomerId"] as! String),OrderID: (dicObj["Id"] as! String))
        }
        if #available(iOS 10.0, *) {
            tblChat.refreshControl = refreshControl
        } else {
            tblChat.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshOrderData(_:)), for: .valueChanged)
        refreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.refreshOrderDataWithTimeInterval), userInfo:nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshOrderData(_ sender: Any) {
        if let Id = userInfo!["Id"]{
            ChatController.GetChatMessage(vc: self, senderID: (Id as! String), receiverID: (dicObj["CustomerId"] as! String),OrderID: (dicObj["Id"] as! String))
        }
        
    }
    
    @objc private func refreshOrderDataWithTimeInterval(_ sender: Any) {
        if let Id = userInfo!["Id"]{
            ChatController.GetChatMessageWithoutLoadder(vc: self, senderID: (Id as! String), receiverID: (dicObj["CustomerId"] as! String),OrderID: (dicObj["Id"] as! String))
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(refreshTimer != nil){
            if(refreshTimer?.isValid == true){
                refreshTimer?.invalidate()
                refreshTimer = nil
            }
        }
    }
    
    @IBAction func btnClickLocation(sender:UIButton){
        let currLocation = "https://www.google.com/maps/search/?api=1&query=\(Constant.currLat.description),\(Constant.currLng.description)"
        var dic = [String:AnyObject]();
        dic["uType"] = "p" as AnyObject;
        dic["isLocation"] = true as AnyObject;
        dic["Sender"] = (userInfo!["Id"] as! String) as AnyObject;
        dic["Receiver"] = (dicObj["CustomerId"] as! String) as AnyObject;
        dic["Message"] = currLocation as AnyObject;
        dic["orderId"] = (dicObj["Id"] as! String) as AnyObject;
        ChatController.SendMessage(vc: self, dicObj: dic)
    }
    
    @IBAction func btnSend(sender:UIButton){
        if(txtChatMsg.text!.count == 0){
            Helper.ShowAlertMessage(message:"Please enter message" , buttonTitle: "OK", vc: self, title: "Required", bannerStyle: .warning)
            return;
        }
        
        var dic = [String:AnyObject]();
        dic["uType"] = "p" as AnyObject;
        dic["isLocation"] = true as AnyObject;
        dic["Sender"] = (userInfo!["Id"] as! String) as AnyObject;
        dic["Receiver"] = (dicObj["CustomerId"] as! String) as AnyObject;
        dic["Message"] = txtChatMsg.text as AnyObject;
        dic["orderId"] = (dicObj["Id"] as! String) as AnyObject;
        ChatController.SendMessage(vc: self, dicObj: dic)
        txtChatMsg.text = "";
    }
    
    func KeyBoardNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(self.KeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func KeyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= (keyboardFrame.height)
        }
    }
    @objc func KeyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        _ = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0 && self.view.frame.origin.y < 0{
            self.view.frame.origin.y = 0
        }
    }
}

extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( ChatController.listChat != nil){
            if( ChatController.listChat!.count>0){
                tableView.restore()
            }else{
                tableView.setEmptyMessage("No Message Found")
            }
            return  ChatController.listChat!.count
        }
        else{
            tableView.setEmptyMessage("No Message Found")
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        if(ChatController.listChat!.count>indexPath.row){
            let dic =  ChatController.listChat![indexPath.row] as! [String:AnyObject]
            
            if((dic["Sender"] as! String) != (userInfo!["Id"] as! String)){
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftCell", for: indexPath) as! ChatLeftCell
                (cell as! ChatLeftCell).SetData(dic: dic)
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightCell", for: indexPath) as! ChatRightCell
                (cell as! ChatRightCell).SetData(dic: dic)
            }
            return (cell ?? nil)!;
        }
        return tableView.dequeueReusableCell(withIdentifier: "ChatLeftCell", for: indexPath) as! ChatLeftCell
    }
}
