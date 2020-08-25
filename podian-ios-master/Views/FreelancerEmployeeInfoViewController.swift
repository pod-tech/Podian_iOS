//
//  FreelancerEmployeeInfoViewController.swift
//  PODPhotographer
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift
class FreelancerEmployeeInfoViewController: UIViewController {
    @IBOutlet var btnScreenshot:UIButton!
    @IBOutlet var txtArea:SkyFloatingLabelTextField!
    @IBOutlet var txtCity:SkyFloatingLabelTextField!
    @IBOutlet var txtState:SkyFloatingLabelTextField!
    @IBOutlet var txtPin:SkyFloatingLabelTextField!
    @IBOutlet var txtAdhaar:SkyFloatingLabelTextField!
    @IBOutlet var btnEmployed:UIButton!
    @IBOutlet var btnUnEMployed:UIButton!
    @IBOutlet var btnSelf:UIButton!
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
        self.InitializeKeyBoardNotificationObserver()
        txtPin.addDoneButtonOnKeyboard(view: self.view)
        self.imagePicker = ImagePicker(presentationController: self,delegate: self)
        self.btnEmployed.isSelected = true;
        Constant.OrderDic!["Employment"] = "Employed" as AnyObject;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSelectEmployeType(sender:UIButton){
        self.btnSelf.isSelected = false;
        self.btnEmployed.isSelected = false;
        self.btnUnEMployed.isSelected = false;
        sender.isSelected = true;
    }
    
    @IBAction func btnScreenSHot_Click(sender:UIButton){
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func btnContinue_Click(sender:UIButton){
       
        if(txtArea.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter area" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtCity.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter city" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtState.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter state" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtPin.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter Pincode" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtAdhaar.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter Aadhar NO" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(!Helper.ValidatePancard(pancard: txtAdhaar.text) && !Helper.ValidateAadharNo(pancard: txtAdhaar.text)){
                Helper.ShowAlertMessage(message:"Please enter valid Pan No/Aadhar NO" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                return;
            }
        else if(isImageSelected == false){
            Helper.ShowAlertMessage(message:"Please add Aadhar/Pancard" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        
        if(isImageSelected){
            Constant.OrderDic!["IdProof"] = imgData as AnyObject?
        }
        else{
            Constant.OrderDic!["IdProof"] = Data.init() as AnyObject
        }
        
        Constant.OrderDic!["Pin"] = txtPin.text as AnyObject;
        Constant.OrderDic!["Area"] = txtArea.text as AnyObject;
        Constant.OrderDic!["City"] = txtCity.text as AnyObject;
        Constant.OrderDic!["State"] = txtState.text as AnyObject;
        Constant.OrderDic!["Country"] = "India" as AnyObject;
        Constant.OrderDic!["Aadhar"] = txtAdhaar.text as AnyObject;
        if(btnEmployed.isSelected){
            Constant.OrderDic!["Employment"] = "Employed" as AnyObject;
        }
        else  if(btnUnEMployed.isSelected){
                   Constant.OrderDic!["Employment"] = "UnEmployed" as AnyObject;
               }
        else  if(btnSelf.isSelected){
            Constant.OrderDic!["Employment"] = "Self-Employed" as AnyObject;
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FreelancerWorkInfoViewController") as! FreelancerWorkInfoViewController
        self.navigationController!.pushViewController(controller, animated: true)
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

extension FreelancerEmployeeInfoViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        imgData = image!.jpegData(compressionQuality: 0.5)
        self.isImageSelected = true;
    }
    
    func didGetFileName(filename: String?) {
        self.btnScreenshot.setTitle(filename, for: UIControl.State.normal)
    }
}
