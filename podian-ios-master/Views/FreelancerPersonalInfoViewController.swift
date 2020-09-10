//
//  FreelancerPersonalInfoViewController.swift
//  PODPhotographer
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift

class FreelancerPersonalInfoViewController: BaseViewController {
    
    @IBOutlet var profileImg:UIImageView!
    @IBOutlet var txtfullName:SkyFloatingLabelTextField!
    @IBOutlet var txtEmail:SkyFloatingLabelTextField!
    @IBOutlet var txtPhoneNo:SkyFloatingLabelTextField!
    @IBOutlet var txtDOB:UITextField!
    @IBOutlet var btnMale:UIButton!
    @IBOutlet var btnFemale:UIButton!
    @IBOutlet var btnPrfer:UIButton!
    @IBOutlet var viewDate:UIView!
     var isImageSelected:Bool = false
    var imagePicker: ImagePicker!
    var imgData:Data!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        Constant.OrderDic = [String:AnyObject]()
        self.InitializeKeyBoardNotificationObserver()
                Helper.SetRoundImage(img: profileImg, cornerRadius: 50, borderWidth: 4, borderColor: UIColor.init(red: 250/255, green: 158/255, blue: 0, alpha: 1))
        txtPhoneNo.addDoneButtonOnKeyboard(view: self.view);
        self.txtDOB.setInputViewDatePicker(target: self, selector: #selector(dateDone),IsFutureDisable:true)
        self.imagePicker = ImagePicker(presentationController: self,delegate: self)
    profileImg.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ProfileViewController.ShowImagePicker)))
        self.btnMale.isSelected = true;
        Constant.OrderDic!["Gender"] = "Male" as AnyObject;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDate.layer.cornerRadius = viewDate.frame.size.height/2;
    }
    
    @objc func ShowImagePicker(){
        self.imagePicker.present(from: profileImg)
    }
    
    @objc func dateDone() {
           if let datePicker = self.txtDOB.inputView as? UIDatePicker { // 2-1
               let dateformatter = DateFormatter() // 2-2
               dateformatter.dateFormat = "dd-MM-yyyy" // 2-3
               self.txtDOB.text = dateformatter.string(from: datePicker.date) //2-4
           }
           self.txtDOB.resignFirstResponder() // 2-5
       }
    
    @IBAction func btnSelectGender(sender:UIButton){
        self.btnMale.isSelected = false;
        self.btnFemale.isSelected = false;
        self.btnPrfer.isSelected = false;
        sender.isSelected = true;
    }
    
    
    @IBAction func btnContinue_Click(sender:UIButton){
        
        
        if(txtfullName.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter name" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtEmail.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter email" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
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
//        else if(txtDOB.text?.count == 0){
//            Helper.ShowAlertMessage(message:"Please select Date of Birth" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
//            return;
//        }
      
        if(isImageSelected){
            Constant.OrderDic!["ProfileImage"] = profileImg.image!.jpegData(compressionQuality: 0.5) as AnyObject?
        }
        else{
            Constant.OrderDic!["ProfileImage"] = Data.init() as AnyObject
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FreelancerEmployeeInfoViewController") as! FreelancerEmployeeInfoViewController
        
       
        Constant.OrderDic!["Name"] = txtfullName.text as AnyObject;
        Constant.OrderDic!["Email"] = txtEmail.text as AnyObject;
        Constant.OrderDic!["Phone"] = txtPhoneNo.text as AnyObject;
        if(btnMale.isSelected){
            Constant.OrderDic!["Gender"] = "Male" as AnyObject;
        }
        else if(btnPrfer.isSelected){
            Constant.OrderDic!["Gender"] = "Prefer not to say" as AnyObject;
        }
        else {
            Constant.OrderDic!["Gender"] = "Female" as AnyObject;
        }
        Constant.OrderDic!["DOB"] = txtDOB.text as AnyObject;
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
    

}

extension FreelancerPersonalInfoViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profileImg.image = image
        isImageSelected = true;
    }
}
