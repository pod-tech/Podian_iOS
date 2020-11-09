//
//  LoginController.swift
//  POD
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
//import FacebookLogin
//import FacebookCore
import SwiftyJSON
//import GoogleSignIn
import NotificationBannerSwift

class LoginController: NSObject {
    
    static func Login(loginUser:LoginUser,vc:LoginViewController){
        do{
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.loginUrl, params: loginUser.toDict(), success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    Helper.ArchivedUserDefaultObject(obj: JSON.dictionaryObject!["ResponseData"]!, key: "UserInfo")
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        vc.navigationController!.pushViewController(controller, animated: true)
                    }
                    
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
            }, failure: { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
            })
        }
        catch let error{
            Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
            vc.removeSpinner()
        }
    }
    
    
    static func SaveUserTrackingData(){
        do{
            let isUserExist = Helper.UnArchivedUserDefaultObject(key: "UserInfo")
            if (!Helper.isObjectNotNil(object: isUserExist as AnyObject)) {
                let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:Any]
                print(Constant.deviceToken)
                var trackInfo = try [String:Any]()
                if let userId = userInfo!["Id"]{
                    trackInfo["userId"] = userId
                }
                trackInfo["lng"] = Constant.currLng
                trackInfo["lat"] = Constant.currLat
                trackInfo["deviceId"] = Constant.deviceToken
                ApiManager.sharedInstance.requestPOSTURL(Constant.insertTrackingDataURL, params: trackInfo, success: {
                    (JSON) in
                    
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        print("Tracked")
                    }
                    else{}
                }, failure: { (Error) in
                })
            }
        }
        catch let _{
            
        }
        
    }
    
    
    static func GetCustomerProfile(vc:LoginViewController,userID:String,IsBack:Bool){
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
    
    static func GetNotificatins(userId:String,vc:HomeViewController){
    do{
        try
        ApiManager.sharedInstance.requestGETURL(Constant.getNotificationbyIDURL+userId, success: { (JSON) in
            let msg =  JSON.dictionary?["Message"]
            if((JSON.dictionary?["IsSuccess"]) != false){
                let listNotification = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                print(listNotification as Any)
                Constant.notificationCount = listNotification!.count;
                vc.lblNotificationCount.text = Constant.notificationCount.description;
            }
            else{
                Constant.notificationCount = 0
                vc.lblNotificationCount.text = 0.description
            }
        }) { (Error) in
            Constant.notificationCount = 0
            vc.lblNotificationCount.text = 0.description
        }
    }
    }
    
}
