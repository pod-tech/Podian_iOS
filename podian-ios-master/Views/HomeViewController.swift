//
//  HomeViewController.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet var lblNotificationCount:UILabel!
     let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:Any]
    
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.SetStatusBarColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LoadNotification();
        lblNotificationCount.text = Constant.notificationCount.description;
        Helper.ISINquery = false;
        if(timer != nil){
            if(timer.isValid){
                timer.invalidate()
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(HomeViewController.LoadNotification), userInfo: nil, repeats: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(timer != nil){
            if(timer.isValid){
                timer.invalidate()
            }
        }
    }
    
    @objc func LoadNotification(){
        if let Id = userInfo!["Id"]{
            DispatchQueue.global(qos: .default).async {
                
                LoginController.GetNotificatins(userId: Id as! String, vc: self)
                DispatchQueue.main.async {
                        
                }
            }
        }
        
    }
    
    @IBAction func  btnShowNotification(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let controller = storyboard.instantiateViewController(withIdentifier: "MyNotificationViewController") as! MyNotificationViewController
               Helper.rootNavigation?.pushViewController(controller, animated: true)
        
    }
}
