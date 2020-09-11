//
//  ExportOrdersPopup.swift
//  PODPhotographer
//
//  Created by Apple on 11/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftDate
import NotificationBannerSwift


class ExportOrdersPopup: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    var fromDate = Date()
     var toDate = Date()
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func fromDateClicked(_ sender: Any) {
        
        let datePicker = ActionSheetDatePicker.init(title: "Select From Date", datePickerMode: .date, selectedDate: Date(), doneBlock: { (picker, value, index) in
                   self.fromDate = value as! Date
                   self.txtFromDate.text = self.fromDate.toFormat("dd-MM-yyyy")
               }, cancel: { (picker) in
                   
               }, origin: sender as? UIView)

        datePicker?.toolbarButtonsColor = UIColor.init(hexString:"#F9B212")
               datePicker?.show()
        
    }
    
    @IBAction func toDateClicked(_ sender: Any) {
        if(txtFromDate.text!.count <= 0){
            Helper.ShowAlertMessage(message: "Please select from date.", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        let datePicker = ActionSheetDatePicker.init(title: "Select To Date", datePickerMode: .date, selectedDate: Date(), doneBlock: { (picker, value, index) in
            self.toDate = value as! Date
            self.txtToDate.text = self.toDate.toFormat("dd-MM-yyyy")
        }, cancel: { (picker) in
            
        }, origin: sender as? UIView)
        datePicker?.minimumDate = fromDate
         datePicker?.toolbarButtonsColor = UIColor.init(hexString:"#F9B212")
        datePicker?.show()
    }
    
    @IBAction func exportClicked(_ sender: Any) {
        if(txtFromDate.text!.count <= 0){
            Helper.ShowAlertMessage(message: "Please select from date.", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        } else if(txtToDate.text!.count <= 0){
            Helper.ShowAlertMessage(message: "Please select to date.", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        
        exportOrderApi()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func exportOrderApi(){
        var dict = [String : Any]()
        dict["photographerId"] = userId
        dict["fromDate"] = fromDate.toFormat("yyyy-MM-dd")
        dict["toDate"] = toDate.toFormat("yyyy-MM-dd")
        startAnimating()
        ApiManager.sharedInstance.requestPOSTURL(Constant.exportOrdersURL, params: dict, success: { (JSON) in
            self.stopAnimating()

            if((JSON.dictionary?["IsSuccess"]) != false){
                let msg : String =  JSON.dictionaryObject?["Message"] as! String
                Helper.ShowAlertMessage(message:msg , vc: self,title:"Error",bannerStyle: BannerStyle.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismiss(animated: true, completion: nil)
                }
//
//                let response = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                let dict : [String : Any] = response![0]
            } else{
                
            }
        }) { (Error) in
            self.stopAnimating()
            Helper.ShowAlertMessage(message:Error.localizedDescription , vc: self,title:"Error",bannerStyle: BannerStyle.danger)
        }
         }
    
}
