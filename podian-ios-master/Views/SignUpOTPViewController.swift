//
//  SignUpOTPViewController.swift
//  POD
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift
class SignUpOTPViewController: UIViewController {
    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var txtOTP:SkyFloatingLabelTextField!
    @IBOutlet var txtPassword:SkyFloatingLabelTextField!
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblEmail:UILabel!
    @IBOutlet var lblMobileNo:UILabel!
    @IBOutlet var lblAdress:UILabel!
    @IBOutlet var btnCheck:UIButton!
    @IBOutlet var bnSignIn:UIButton!
    @IBOutlet var sv:UIScrollView!
    public var userInfo:[String:AnyObject]!
    var imgData:Data = Data.init()
    var IsAcceptTC:Bool = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
        Helper.SetRoundImage(img: profileImg, cornerRadius: 50, borderWidth: 4, borderColor: UIColor.init(red: 250/255, green: 158/255, blue: 0, alpha: 1))
        // Do any additional setup after loading the view.
        sv.contentSize = CGSize.init(width: 0, height: bnSignIn.frame.origin.y+bnSignIn.frame.size.height+50)
        self.SetUserInfo();
    }
    
    func SetUserInfo(){

        if let name = userInfo!["Name"]{
            lblName.text = (name as! String);
        }
        if let Address = userInfo!["Address"]{
            lblAdress.text = (Address as! String);
        }
        if let mobileNo = userInfo?["Phone"]{
            lblMobileNo.text = (mobileNo as! String);
        }
        if let email = userInfo?["Email"]{
            lblEmail.text = (email as! String);
        }
        if let profileImage = userInfo?["ProfileImage"]{
            imgData = ((profileImage as! NSData) as Data)
            profileImg.image = UIImage.init(data: imgData)
            
        }
        var otpDic = [String:AnyObject]()
        otpDic["Name"] = lblName.text as AnyObject
        otpDic["Email"] = lblEmail.text as AnyObject
        otpDic["Phone"] = lblMobileNo.text as AnyObject
        SignupController.GetOTP(vc: self, dicObj: otpDic)
        //userInfo.removeValue(forKey: "ProfileImage")
        
    }
    
    @IBAction func btnTC_Click(){
        if(btnCheck.isSelected)
        {
            btnCheck.isSelected = false
            IsAcceptTC = false
        }
        else{
            btnCheck.isSelected = true
                     IsAcceptTC = true
        }
    }
    
    @IBAction func btnSignIn_Click(){
        if(txtOTP.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter received OTP" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtPassword.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter password" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(!self.IsAcceptTC){
            Helper.ShowAlertMessage(message:"Please accept terms and conditions" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        txtPassword.resignFirstResponder()
        txtOTP.resignFirstResponder()
        
        userInfo?["OTP"]=txtOTP.text as AnyObject?
        userInfo?["Password"]=txtPassword.text as AnyObject?
        userInfo?["SignBy"] = "1" as AnyObject?
        userInfo?["SocialId"] = "1" as AnyObject?
        SignupController.UserRegistration(vc: self, dicObj: userInfo)
    }
    
     @IBAction func btnResend_Click(){
        txtPassword.resignFirstResponder()
        txtOTP.resignFirstResponder()
        
        var otpDic = [String:AnyObject]()
        otpDic["Name"] = lblName.text as AnyObject
        otpDic["Email"] = lblEmail.text as AnyObject
        otpDic["Phone"] = lblMobileNo.text as AnyObject
        SignupController.ReGetOTP(vc: self, dicObj: otpDic)
     }
    

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
