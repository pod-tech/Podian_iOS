//
//  FreelancerSubmitInfoViewController.swift
//  PODPhotographer
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class FreelancerSubmitInfoViewController: BaseViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var pickerView = UIPickerView()
    var pickerViewJoinAS = UIPickerView()
    @IBOutlet var txtKnow:UITextField!
    @IBOutlet var txtMedia:UITextField!
    @IBOutlet var txtJoinAs:UITextField!
    @IBOutlet var btnYes:UIButton!
    @IBOutlet var btnNo:UIButton!
    @IBOutlet var btnCheck:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        InitializeKeyBoardNotificationObserver()
        FreelancerController.SetList()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerViewJoinAS.delegate = self
        pickerViewJoinAS.dataSource = self
        txtMedia.inputView = pickerView
        txtJoinAs.inputView = pickerViewJoinAS
        //txtJoinAs.setDismissToolBar(target: self)
        //txtMedia.setDismissToolBar(target: self)
        txtMedia.setDismissToolBar(target: self, selector: #selector(FreelancerSubmitInfoViewController.btnMediaSelect))
        txtJoinAs.setDismissToolBar(target: self, selector: #selector(FreelancerSubmitInfoViewController.btJoinUsSelect))
        
        btnYes.isSelected = true;
        Constant.OrderDic!["ReadyToTrawelPodProject"] = "Yes"
    }
    
    @objc func btnMediaSelect(){
        txtMedia.text =  FreelancerController.listMedia![pickerView.selectedRow(inComponent: 0)] as String
        txtMedia!.resignFirstResponder() // 2-5
    }
    
    @objc func btJoinUsSelect(){
        txtJoinAs.text =  FreelancerController.listJoinUs![pickerViewJoinAS.selectedRow(inComponent: 0)] as String
        txtJoinAs!.resignFirstResponder() // 2-5
    }
    
    @IBAction func btnSelect(sender:UIButton){
        self.btnYes.isSelected = false;
        self.btnNo.isSelected = false;
        sender.isSelected = true;
        if(sender == btnYes){
            Constant.OrderDic!["ReadyToTrawelPodProject"] = "Yes"
        }
        else{
            Constant.OrderDic!["ReadyToTrawelPodProject"] = "No"
        }
    }
    
    @IBAction func btnSelectTC(sender:UIButton){
        
        sender.isSelected = !sender.isSelected;
        
    }
    
    @IBAction func btnSubmit(sender:UIButton){
        if(txtKnow.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter description" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtJoinAs.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please select Join as a." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(txtMedia.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please select referral." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        else if(!btnCheck.isSelected){
            Helper.ShowAlertMessage(message:"Please select terms and condition." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        Constant.OrderDic!["Source"] = txtMedia.text
        Constant.OrderDic!["aboutPOD"] = txtKnow.text
        Constant.OrderDic!["RegType"] = txtJoinAs.text 
        FreelancerController.FreelancerRegistration(vc: self, dicObj: Constant.OrderDic!)
    }
}

extension FreelancerSubmitInfoViewController{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == pickerViewJoinAS){
            return FreelancerController.listJoinUs!.count
        }
        return FreelancerController.listMedia!.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerViewJoinAS){
            return FreelancerController.listJoinUs![row] as String
        }
        return FreelancerController.listMedia![row] as String
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == pickerViewJoinAS){
            txtJoinAs.text =  FreelancerController.listJoinUs![row] as String
            return;
        }
        txtMedia.text =  FreelancerController.listMedia![row] as String
    }
}
