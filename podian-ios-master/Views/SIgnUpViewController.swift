//
//  SIgnUpViewController.swift
//  POD
//
//  Created by Apple on 29/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift

class SIgnUpViewController: BaseViewController {

    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var txtfullName:SkyFloatingLabelTextField!
    @IBOutlet var txtEmail:SkyFloatingLabelTextField!
    @IBOutlet var txtPhoneNo:SkyFloatingLabelTextField!
    @IBOutlet var txtAddress:SkyFloatingLabelTextField!
    @IBOutlet var sv:UIScrollView!
    @IBOutlet var btnSubmit:UIButton!
    var imagePicker: ImagePicker!
    var isImageSelected:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
        Helper.SetRoundImage(img: profileImg, cornerRadius: 50, borderWidth: 4, borderColor: UIColor.init(red: 250/255, green: 158/255, blue: 0, alpha: 1))
        self.SetStatusBarColor()
        txtPhoneNo.addDoneButtonOnKeyboard(view: self.view);
        self.imagePicker = ImagePicker(presentationController: self,delegate: self)
        profileImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(SIgnUpViewController.ShowImagePicker)))
         sv.contentSize = CGSize.init(width: 0, height: btnSubmit.frame.origin.y+btnSubmit.frame.size.height)
        // Do any additional setup after loading the view.
    }
    
    @objc func ShowImagePicker(){
        self.imagePicker.present(from: profileImg)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    @IBAction func btnVerifyOTP(){
        if(txtfullName.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter fullname" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtEmail.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter email" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtAddress.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter address" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtPhoneNo.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter phoneno" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(!isImageSelected){
            Helper.ShowAlertMessage(message:"Please select profile image" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        var userInfo = [String:Any]()
        if(isImageSelected){
            userInfo["ProfileImage"] = profileImg.image!.jpegData(compressionQuality: 0.5)
        }
        else{
            userInfo["ProfileImage"] = Data.init()
        }
        userInfo["Name"] = txtfullName.text
        userInfo["Email"] = txtEmail.text
        userInfo["Phone"] = txtPhoneNo.text
        userInfo["Address"] = txtAddress.text
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignUpOTPViewController") as! SignUpOTPViewController
        controller.userInfo = userInfo;
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
    
    
}

extension SIgnUpViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profileImg.image = image
        isImageSelected = true;
    }
}
