//
//  ProfileViewController.swift
//  POD
//
//  Created by Apple on 01/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift

class ProfileViewController: BaseViewController {

    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var txtfullName:SkyFloatingLabelTextField!
    @IBOutlet var txtEmail:SkyFloatingLabelTextField!
    @IBOutlet var txtPhoneNo:SkyFloatingLabelTextField!
    @IBOutlet var txtAddress:SkyFloatingLabelTextField!
    @IBOutlet var lblPhotGrapherID:UILabel!
//    @IBOutlet var sv:UIScrollView!
    @IBOutlet var btnSubmit:UIButton!
    @IBOutlet var activityInd:UIActivityIndicatorView!
    var imagePicker: ImagePicker!
    var imgData:Data!
    override func viewDidLoad() {
        super.viewDidLoad();
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
         self.InitializeKeyBoardNotificationObserver()
         Helper.SetRoundImage(img: profileImg, cornerRadius: 50, borderWidth: 4, borderColor: UIColor.init(red: 250/255, green: 158/255, blue: 0, alpha: 1))
        self.SetStatusBarColor()
        self.imagePicker = ImagePicker(presentationController: self,delegate: self)
        profileImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ProfileViewController.ShowImagePicker)))
//        sv.contentSize = CGSize.init(width: 0, height: btnSubmit.frame.origin.y+btnSubmit.frame.size.height)
        txtEmail.isUserInteractionEnabled = false
        txtPhoneNo.isUserInteractionEnabled = false;
        self.btnSubmit.isEnabled = false;
         self.LoadProfileData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func ShowImagePicker(){
        self.imagePicker.present(from: profileImg)
    }
    
    func LoadProfileData(){
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
        if let Id = userInfo!["Id"]{
            lblPhotGrapherID.text = "Photographer id: #PODPH\(Id as! String)";
        }
        if let name = userInfo!["Name"]{
            txtfullName.text = (name as! String);
        }
        if let Address = userInfo!["Address"]{
            txtAddress.text = (Address as! String);
        }
        if let mobileNo = userInfo?["Phone"]{
            txtPhoneNo.text = (mobileNo as! String);
            if(txtPhoneNo.text?.count == 0)
            {
                 txtPhoneNo.isEnabled = true;
            }
        }
        if let email = userInfo?["Email"]{
            txtEmail.text = (email as! String);
        }
       
        if let imgURL = userInfo?["ProfileImage"]{
            self.activityInd.isHidden = false;
            self.activityInd.startAnimating()
            let imageUrl:NSURL = NSURL(string:  (imgURL as! String))!
            if(imageUrl.absoluteString?.count != 0){
            DispatchQueue.global(qos: .default).async {
            
                let imageData:NSData = NSData(contentsOf: imageUrl as URL) ?? NSData.init()
                DispatchQueue.main.async {
                           let image = UIImage(data: imageData as Data)
                        self.profileImg.image = image
                        self.profileImg.contentMode = UIView.ContentMode.scaleAspectFit
                        self.activityInd.stopAnimating()
                        self.activityInd.isHidden = true;
                        self.btnSubmit.isEnabled = true;
                       }
                   }
            }
            else{
                self.activityInd.stopAnimating()
                self.activityInd.isHidden = true;
                self.btnSubmit.isEnabled = true;
            }
        }
        else{
            self.activityInd.stopAnimating()
            self.activityInd.isHidden = true;
            self.btnSubmit.isEnabled = true;
        }
        
    }
    
    @IBAction func btnUpdate_Click(){
        if(txtEmail.text?.count == 0){
                Helper.ShowAlertMessage(message:"Please enter email." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
               else if(txtAddress.text?.count == 0){
                Helper.ShowAlertMessage(message:"Please enter address." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
              else if(txtPhoneNo.text?.count == 0){
                Helper.ShowAlertMessage(message:"Please enter phone no." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                return;
               }
               else if(txtfullName.text?.count == 0){
                              Helper.ShowAlertMessage(message:"Please enter full name." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                              return;
                             }
             
               txtfullName.resignFirstResponder()
               txtPhoneNo.resignFirstResponder()
               txtAddress.resignFirstResponder()
                txtEmail.resignFirstResponder()
               let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
               var otpDic = [String:AnyObject]()
               if let Id = userInfo!["Id"]{
                    otpDic["Id"] = Id as AnyObject
               }
                otpDic["ProfileImage"] = profileImg.image!.jpegData(compressionQuality: 0.5) as AnyObject?
               otpDic["Name"] = txtfullName.text as AnyObject
               otpDic["Address"] = txtAddress.text as AnyObject
              otpDic["Phone"] = txtPhoneNo.text as AnyObject
        ProfileController.UpdateUserProfile(vc: self, dicObj: otpDic)
    }
    
}
extension ProfileViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profileImg.image = image
    }
}
