//
//  SenOTPPopupViewController.swift
//  PODPhotographer
//
//  Created by Apple on 30/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class SenOTPPopupViewController: BaseViewController {

    @IBOutlet var txtOTP:UITextField!
    public var dicObj:[String:AnyObject] = [:]
    public var vc:OrderDetailViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
   
    @IBAction func btnClose(){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnSubmitOTP(){
        if(txtOTP.text?.count == 0){
            Helper.ShowAlertMessage(message: "Please enter received OTP", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return
        }
        var dic:[String:AnyObject] = [String:AnyObject]();
        dic["OrderId"] = dicObj["OrderId"];
        dic["PhotographerId"] = dicObj["PhotographerId"];
        dic["CustomerId"] = dicObj["CustomerId"];
        dic["OTP"] = txtOTP.text as AnyObject?;
        OrderController.SUbmitOrderOTPtoCustomer(vc: vc!, dicObj: dic as [String : AnyObject])
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnResendOTP(){
        
        var dic:[String:Any] = [String:AnyObject]();
        dic["OrderId"] = dicObj["OrderId"];
        dic["PhotographerId"] = dicObj["PhotographerId"];
        dic["CustomerId"] = dicObj["CustomerId"];
        OrderController.ResendOTPtoCustomer(vc: self, dicObj: dic as [String : AnyObject])
    }
}
