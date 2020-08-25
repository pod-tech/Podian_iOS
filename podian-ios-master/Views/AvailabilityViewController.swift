//
//  AvailabilityViewController.swift
//  PODPhotographer
//
//  Created by Apple on 08/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class AvailabilityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var btnAddAvail:UIButton!
    @IBOutlet var btnYourAvail:UIButton!
    @IBOutlet public var tblAddAvail:UITableView!
    @IBOutlet var tblYourAvail:UITableView!
    @IBOutlet var viewNotice:UIView!
    @IBOutlet var viewDate:UIView!
    @IBOutlet var txtContact:UITextField!
    public let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.txtContact.setInputViewDatePicker(target: self, selector: #selector(dateDone),IsPreviousDisable:true)
        self.btnAddAvail.isSelected = true;
        self.btnYourAvail.isSelected = false;
        self.tblYourAvail.isHidden = true;
        self.tblAddAvail.isHidden = false;
        tblYourAvail.rowHeight = UITableView.automaticDimension
        tblYourAvail.estimatedRowHeight = 130
         self.txtContact.tintColor = UIColor.clear
        AvailabilityController.InitializeAvailabilityTime(vc:self)
        if #available(iOS 10.0, *) {
                   tblYourAvail!.refreshControl = refreshControl
              } else {
                   tblYourAvail!.addSubview(refreshControl)
              }
        self.GetAvailability()
        refreshControl.addTarget(self, action: #selector(refreshAvailabilityData(_:)), for: .valueChanged)
        
    }
    
   
    
    @objc private func refreshAvailabilityData(_ sender: Any) {
        // Fetch Weather Data
        self.GetAvailability()
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if(textField == txtContact){
            return false
        }
        return true
    }
    
    @objc func dateDone() {
        if let datePicker = self.txtContact.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd-MM-yyyy" // 2-3
            self.txtContact.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtContact.resignFirstResponder() // 2-5
    }
    
    @IBAction func btnSubmit_Click(sender:UIButton){
        var isSelected:Bool = false;
        print(txtContact.text!.count)
        if(txtContact.text!.count == 0){
            Helper.ShowAlertMessage(message: "Please select date", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
       
        var objDIC = [String:AnyObject]()
        if let Id = userInfo!["Id"]{
             objDIC["photographerId"] = Id as AnyObject
        }
        objDIC["Date"] = txtContact.text as AnyObject;
        
        let nightAM = AvailabilityController.availabilityList![0] as! [String:AnyObject]
        let arrNightAMTIime = nightAM["Times"] as! [[String:AnyObject]]
        
        for time in arrNightAMTIime {
            if((time["status"] as! Bool) == true){
                isSelected = true;
                break;
            }
        }
        
        let morningAM = AvailabilityController.availabilityList![1] as! [String:AnyObject]
        let arrmorningAMTIime = morningAM["Times"] as! [[String:AnyObject]]
        
        if(isSelected == false){
            for time in arrmorningAMTIime {
                if((time["status"] as! Bool) == true){
                    isSelected = true;
                    break;
                }
            }
        }
        
        let AfternoonPM = AvailabilityController.availabilityList![2] as! [String:AnyObject]
               let arrAfterNoonTIime = AfternoonPM["Times"] as! [[String:AnyObject]]
        if(isSelected == false){
            for time in arrAfterNoonTIime {
                if((time["status"] as! Bool) == true){
                    isSelected = true;
                    break;
                }
            }
        }
        
        let eveningPM = AvailabilityController.availabilityList![3] as! [String:AnyObject]
        let arrEveningTIime = eveningPM["Times"] as! [[String:AnyObject]]
        if(isSelected == false){
                   for time in arrEveningTIime {
                       if((time["status"] as! Bool) == true){
                           isSelected = true;
                           break;
                       }
                   }
               }
        
        if(isSelected == false){
            Helper.ShowAlertMessage(message: "Please select time", vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        
        
        objDIC["00:00"] = (arrNightAMTIime[0] )["status"] as AnyObject;
        objDIC["00:30"] = (arrNightAMTIime[1] )["status"] as AnyObject;
        objDIC["1:00"] = (arrNightAMTIime[2] )["status"] as AnyObject;
        objDIC["1:30"] = (arrNightAMTIime[3] )["status"] as AnyObject;
        objDIC["2:00"] = (arrNightAMTIime[4] )["status"] as AnyObject;
        objDIC["2:30"] = (arrNightAMTIime[5] )["status"] as AnyObject;
        objDIC["3:00"] = (arrNightAMTIime[6] )["status"] as AnyObject;
        objDIC["3:30"] = (arrNightAMTIime[7] )["status"] as AnyObject;
        objDIC["4:00"] = (arrNightAMTIime[8] )["status"] as AnyObject;
        objDIC["4:30"] = (arrNightAMTIime[9] )["status"] as AnyObject;
        objDIC["5:00"] = (arrNightAMTIime[10] )["status"]as AnyObject;
        objDIC["5:30"] = (arrNightAMTIime[11] )["status"] as AnyObject;
        objDIC["6:00"] = (arrmorningAMTIime[0] )["status"] as AnyObject;
        objDIC["6:30"] = (arrmorningAMTIime[1] )["status"] as AnyObject;
        objDIC["7:00"] = (arrmorningAMTIime[2])["status"] as AnyObject;
        objDIC["7:30"] = (arrmorningAMTIime[3] )["status"] as AnyObject;
        objDIC["8:00"] = (arrmorningAMTIime[4] )["status"] as AnyObject;
        objDIC["8:30"] = (arrmorningAMTIime[5] )["status"] as AnyObject;
        objDIC["9:00"] = (arrmorningAMTIime[6] )["status"] as AnyObject;
        objDIC["9:30"] = (arrmorningAMTIime[7] )["status"] as AnyObject;
        objDIC["10:00"] = (arrmorningAMTIime[8] )["status"] as AnyObject;
        objDIC["10:30"] = (arrmorningAMTIime[9] )["status"] as AnyObject;
        objDIC["11:00"] = (arrmorningAMTIime[10] )["status"] as AnyObject;
        objDIC["11:30"] = (arrmorningAMTIime[11] )["status"] as AnyObject;
        objDIC["12:00"] = (arrAfterNoonTIime[0] )["status"] as AnyObject;
        objDIC["12:30"] = (arrAfterNoonTIime[1] )["status"] as AnyObject;
        objDIC["13:00"] = (arrAfterNoonTIime[2] )["status"] as AnyObject;
        objDIC["13:30"] = (arrAfterNoonTIime[3] )["status"] as AnyObject;
        objDIC["14:00"] = (arrAfterNoonTIime[4] )["status"] as AnyObject;
        objDIC["14:30"] = (arrAfterNoonTIime[5] )["status"] as AnyObject;
        objDIC["15:00"] = (arrAfterNoonTIime[6] )["status"] as AnyObject;
        objDIC["15:30"] = (arrAfterNoonTIime[7] )["status"] as AnyObject;
        objDIC["16:00"] = (arrAfterNoonTIime[8] )["status"] as AnyObject;
        objDIC["16:30"] = (arrAfterNoonTIime[9] )["status"] as AnyObject;
        objDIC["17:00"] = (arrAfterNoonTIime[10] )["status"] as AnyObject;
        objDIC["17:30"] = (arrAfterNoonTIime[11] )["status"] as AnyObject;
        objDIC["18:00"] = (arrEveningTIime[0] )["status"] as AnyObject;
        objDIC["18:30"] = (arrEveningTIime[1] )["status"] as AnyObject;
        objDIC["19:00"] = (arrEveningTIime[2] )["status"] as AnyObject;
        objDIC["19:30"] = (arrEveningTIime[3] )["status"] as AnyObject;
        objDIC["20:00"] = (arrEveningTIime[4] )["status"] as AnyObject;
        objDIC["20:30"] = (arrEveningTIime[5] )["status"] as AnyObject;
        objDIC["21:00"] = (arrEveningTIime[6] )["status"] as AnyObject;
        objDIC["21:30"] = (arrEveningTIime[7] )["status"] as AnyObject;
        objDIC["22:00"] = (arrEveningTIime[8] )["status"] as AnyObject;
        objDIC["22:30"] = (arrEveningTIime[9] )["status"] as AnyObject;
        objDIC["23:00"] = (arrEveningTIime[10] )["status"] as AnyObject;
        objDIC["23:30"] = (arrEveningTIime[11] )["status"] as AnyObject;
        objDIC["24:30"] = "0" as AnyObject;
        AvailabilityController.AddAvailabilty(vc: self, dicObj: objDIC)
        
    }
    
    func GetAvailability(){
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
         if let Id = userInfo!["Id"]{
            AvailabilityController.GetAvailability(vc: self, photographerID: Id as! String)
         }
    }
    
    @IBAction func btnTabs_Click(sender:UIButton){
        self.btnAddAvail.isSelected = false;
        self.btnYourAvail.isSelected = false;
        self.tblYourAvail.isHidden = true;
        self.tblAddAvail.isHidden = true;
        self.viewDate.isHidden = true;
        self.viewNotice.isHidden = true;
        if(sender.tag == 1){
            self.tblAddAvail.isHidden = false;
            self.btnAddAvail.isSelected = true;
            self.viewDate.isHidden = false;
            self.viewNotice.isHidden = false;
        }
        else{
            self.tblYourAvail.isHidden = false;
            self.btnYourAvail.isSelected = true;
            self.viewDate.isHidden = true;
            self.viewNotice.isHidden = true;
                       
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblAddAvail){
        if(AvailabilityController.availabilityList != nil){
            return AvailabilityController.availabilityList!.count;
        }
        else{
            return 0
        }
        }
        else{
            if(AvailabilityController.userAvailabilityList != nil){
                return AvailabilityController.userAvailabilityList!.count;
            }
            else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == tblAddAvail){
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailibilityTableViewCell", for: indexPath as IndexPath) as! AvailibilityTableViewCell
            cell.SetData(dic: AvailabilityController.availabilityList![indexPath.row],indexPath: indexPath)
        return cell
        }
        else if(tableView == tblYourAvail){
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourAvailabilityTableViewCell", for: indexPath as IndexPath) as! YourAvailabilityTableViewCell
            cell.SetData(dic: AvailabilityController.userAvailabilityList![indexPath.row])
        return cell
        }
        
        return UITableViewCell.init()
    }
    

}
