//
//  ForgetPasswordViewController.swift
//  PODPhotographer
//
//  Created by Apple on 18/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class ForgetPasswordViewController: BaseViewController {
    
    @IBOutlet var txtEmail:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver(); self.navigationController?.setNavigationBarHidden(true, animated: true);
        self.SetStatusBarColor()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnContinue_Click(){
        if(txtEmail.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter registered email or phoneno" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        txtEmail.resignFirstResponder()
        var otpDic = [String:Any]()
        otpDic["E_O_P"] = txtEmail.text
        ForgetPassController.ForgetPasswordSendOTP(vc:self,dicObj:otpDic)
    }
}
