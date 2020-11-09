//
//  LoginViewController.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleSignIn
import NotificationBannerSwift

class LoginViewController: BaseViewController {
    
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPassword:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
//        GIDSignIn.sharedInstance().delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    
    @IBAction func btnLoginClick(){
        if(txtEmail.text!.count == 0){
                Helper.ShowAlertMessage(message: "Please enter email/phoneno.", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                return;
            }
            if(txtPassword.text!.count == 0){
                Helper.ShowAlertMessage(message: "Please enter password.", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                return;
            }
            txtEmail.resignFirstResponder()
                   txtPassword.resignFirstResponder()
            let loginUser = LoginUser.init(username: txtEmail.text!, password: txtPassword.text!)
            LoginController.Login(loginUser: loginUser, vc: self);
        }
    override func viewWillAppear(_ animated: Bool) {
        Constant.notificationCount = 0;
    }
}



