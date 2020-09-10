//
//  FreelancerSocialInfoViewController.swift
//  PODPhotographer
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift

class FreelancerSocialInfoViewController: BaseViewController {
    @IBOutlet var txtInstaURL:SkyFloatingLabelTextField!
    @IBOutlet var txyProtURL:SkyFloatingLabelTextField!
    @IBOutlet var txtBody:SkyFloatingLabelTextField!
    @IBOutlet var txtLens1:SkyFloatingLabelTextField!
    @IBOutlet var txtLens2:SkyFloatingLabelTextField!
    @IBOutlet var txtLens3:SkyFloatingLabelTextField!
    
    @IBOutlet var btnALl:UIButton!
    @IBOutlet var btnMor:UIButton!
    @IBOutlet var btnEve:UIButton!
    @IBOutlet var btnLate:UIButton!
    @IBOutlet var btnWeek:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.InitializeKeyBoardNotificationObserver()
        self.btnALl.isSelected = true;
        Constant.OrderDic!["Availibility"] = "All days (24*7)" as AnyObject;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnContinue_Click(sender:UIButton){
        
        if(txtInstaURL.text?.count == 0){
                   Helper.ShowAlertMessage(message:"Please enter Instagram URL" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
               else if(txyProtURL.text?.count == 0){
                   Helper.ShowAlertMessage(message:"Please enter Portfolio URL" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
               else if(txtBody.text?.count == 0){
                   Helper.ShowAlertMessage(message:"Please enter Camera body information." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
               else if(txtLens1.text?.count == 0){
                   Helper.ShowAlertMessage(message:"Please enter Lenses information." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
               else if(txtLens2.text?.count == 0){
                   Helper.ShowAlertMessage(message:"Please enter Lenses information." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
                   return;
               }
        else if(txtLens3.text?.count == 0){
            Helper.ShowAlertMessage(message:"Please enter Lenses information." , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
               
               Constant.OrderDic!["InstagramURL"] = txtInstaURL.text as AnyObject;
               Constant.OrderDic!["PortfolioUrl"] = txyProtURL.text as AnyObject;
               Constant.OrderDic!["CameraBody"] = txtBody.text as AnyObject;
               Constant.OrderDic!["Lances1"] = txtLens1.text as AnyObject;
               Constant.OrderDic!["Lances2"] = txtLens2.text as AnyObject;
                Constant.OrderDic!["Lances3"] = txtLens3.text as AnyObject;
       
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FreelancerSubmitInfoViewController") as! FreelancerSubmitInfoViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnSelectDays(sender:UIButton){
        self.btnALl.isSelected = false;
        self.btnMor.isSelected = false;
        self.btnEve.isSelected = false;
        self.btnLate.isSelected = false;
        self.btnWeek.isSelected = false;
        sender.isSelected = true;
        if(btnALl == sender){
            Constant.OrderDic!["Availibility"] = "All days (24*7)" as AnyObject;
        }
        else if(btnMor == sender){
            Constant.OrderDic!["Availibility"] = "Early Mornings(5AM-8AM)" as AnyObject;
        }
        else if(btnEve == sender){
            Constant.OrderDic!["Availibility"] = "Evening(5PM-8PM)" as AnyObject;
        }
        else if(btnLate == sender){
            Constant.OrderDic!["Availibility"] = "Late Nights(8PM-12AM)" as AnyObject;
        }
        else if(btnWeek == sender){
            Constant.OrderDic!["Availibility"] = "Weekends(24*2)" as AnyObject;
        }
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
