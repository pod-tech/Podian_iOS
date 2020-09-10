//
//  LoginController.swift
//  POD
//
//  Created by Apple on 04/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import SwiftyJSON
import GoogleSignIn
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
                let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
                print(Constant.deviceToken)
                var trackInfo = try [String:AnyObject]()
                if let userId = userInfo!["Id"]{
                    trackInfo["userId"] = userId
                }
                trackInfo["lng"] = Constant.currLng as AnyObject
                trackInfo["lat"] = Constant.currLat as AnyObject
                trackInfo["deviceId"] = Constant.deviceToken  as AnyObject;
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
    
   
    
    public static func LoginWithFaceBook(vc:LoginViewController){
        do{
            let loginManager = LoginManager()
            loginManager.logOut()
            loginManager.logIn(
                permissions: [.publicProfile,.email],
                viewController: vc
            ) { result in
                switch result {
                case .cancelled: break
                    
                case .failed( _): break
                    
                case .success( _, _, _):
                    vc.showSpinner();
                    if let accessToken = AccessToken.current?.tokenString {
                        fetchUserProfile(vc:vc,loginToken:accessToken);
                    }
                }
            }
        }
        catch _{
            //Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc)
            //vc.removeSpinner(onView: vc.view)
        }
    }
    
    public static func LoginWithGoogle(vc:UIViewController){
        do{
            GIDSignIn.sharedInstance()?.presentingViewController = vc;
            GIDSignIn.sharedInstance()?.signIn()
        }
        catch let error{
            //Helper.ShowAlertMessage(message: error.localizedDescription, vc: vc)
            //vc.removeSpinner(onView: vc.view)
        }
    }
    
    static func fetchUserProfile(vc:LoginViewController,loginToken:String)
    {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480),location"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error took place: \(error)")
                vc.removeSpinner()
                Helper.ShowAlertMessage(message: error!.localizedDescription, vc: vc)
            }
            else
            {
                print("Print entire fetched result: \(JSON(result!))")
                var userInfo:[String:AnyObject] = [String:AnyObject]()
                let pictureData = JSON(result!).dictionaryObject!["picture"] as! NSDictionary
                let data = JSON(pictureData).dictionaryObject!["data"] as! NSDictionary
                let pictureUrlString  = data["url"] as! String
                let pictureUrl = NSURL(string: pictureUrlString)
                let imageData:NSData = NSData(contentsOf: pictureUrl as! URL)!
                if(imageData != nil){
                    userInfo["ProfileImage"] = imageData
                }
                else{
                    userInfo["ProfileImage"] = Data.init() as AnyObject
                }
                userInfo["Name"] = JSON(result!).dictionaryObject!["name"] as AnyObject
                userInfo["Email"] = JSON(result!).dictionaryObject!["email"] as AnyObject
                userInfo["Phone"] = "" as AnyObject
                userInfo["Address"] = JSON(result!).dictionaryObject!["location"] as AnyObject
                userInfo["OTP"] = "" as AnyObject?
                userInfo["Password"] = ""  as AnyObject?
                userInfo["SignBy"] = "2" as AnyObject?
                userInfo["SocialId"] = "2" as AnyObject?
                LoginController.FacebookRegistration(vc: vc, dicObj: userInfo)
            }
            //vc.removeSpinner(onView: vc.view)
        })
    }
    
    static func FacebookRegistration(vc:LoginViewController,dicObj:[String:AnyObject]){
        do{
            
            ApiManager.sharedInstance.requestPOSTMultiPartURL(endUrl: Constant.signUpUrl, imageData: dicObj["ProfileImage"] as! Data, parameters: dicObj, success: { (JSON) in
                let result = JSON.string?.parseJSONString
                vc.removeSpinner()
                let msg =  result!["Message"]
                if(((result!["IsSuccess"]) as! Bool) != false){
                    var data =  (result!["ResponseData"]!)!;
//                    print((((result!["ResponseData"]!)! as! [String:AnyObject])["Id"])!)
                    self.GetCustomerProfile(vc: vc, userID: (((result!["ResponseData"]!)! as! [String:AnyObject])["Id"])! as! String,IsBack: false)
                }
                else{
                    Helper.ShowAlertMessage(message:msg as! String , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                
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
