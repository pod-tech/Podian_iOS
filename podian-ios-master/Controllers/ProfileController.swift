//
//  ProfileController.swift
//  PODPhotographer
//
//  Created by Apple on 10/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class ProfileController: NSObject {
    
    static func UpdateUserProfile(vc:ProfileViewController,dicObj:[String:Any]){
           do{
               vc.showSpinner();
               ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.updateCustomerProfileURL, imageData: dicObj["ProfileImage"] as! Data, parameters: dicObj, success: { (JSON) in
                   let result = JSON.string?.parseJSONString
                   let msg =  result!["Message"]
                   if(((result!["IsSuccess"]) as! Bool) != false){
                       self.GetCustomerProfile(vc: vc, userID: (dicObj["Id"])! as! String,IsBack: true)
                       Helper.ShowAlertMessage(message:msg as! String , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
                   }
                   else{
                       Helper.ShowAlertMessage(message:msg as! String , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                   }
                   vc.removeSpinner()
               }, failure:{ (Error) in
                   Helper.ShowAlertMessage(message:Error.localizedDescription , vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                   vc.removeSpinner()
               })
           }
           catch let error{
               Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
               vc.removeSpinner()
           }
           
       }
    
    static func GetCustomerProfile(vc:ProfileViewController,userID:String,IsBack:Bool){
          do{
              try
                  vc.showSpinner()
              ApiManager.sharedInstance.requestGETURL(Constant.getCustomerProfileURL+"/"+userID, success: { (JSON) in
                  let msg =  JSON.dictionary?["Message"]
                  if((JSON.dictionary?["IsSuccess"]) != false){
                      Helper.ArchivedUserDefaultObject(obj: JSON.dictionaryObject!["ResponseData"]!, key: "UserInfo")
                      DispatchQueue.main.async {
                          if(IsBack == false){
                          let storyboard = UIStoryboard(name: "Main", bundle: nil)
                          let controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                          vc.navigationController!.pushViewController(controller, animated: true)
                          }else{
                              vc.navigationController!.popViewController(animated: true)
                          }
                      }
                  }
                  else{
                      //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                  }
                  vc.removeSpinner()
                 
              }) { (Error) in
                  Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                  vc.removeSpinner()
              }
              
          }
         
      }

}
