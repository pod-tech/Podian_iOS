//
//  AvailabilityController.swift
//  PODPhotographer
//
//  Created by Apple on 27/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class AvailabilityController: NSObject {
    
    public static var availabilityList:[[String:Any]]?
    public static var userAvailabilityList:[[String:Any]]?
    public static var tblAvail:UITableView?
    static func InitializeAvailabilityTime(vc:AvailabilityViewController){
        
        AvailabilityController.availabilityList = [[String:Any]]()
        
        let NightAmTimeArray = ["12-12:30 AM","12:30-01 AM","01-01:30 AM","01:30-02 AM","02-02:30 AM","02:30-03 AM","03-03:30 AM","03:30-04 AM","04-04:30 AM","04:30-05 AM","05-05:30 AM","05:30-06 AM"]
        
        let MorningAmTimeArray = ["06-06:30 AM","06:30-07 AM","07-07:30 AM","07:30-08 AM","08-08:30 AM","08:30-09 AM","09-09:30 AM","09:30-10 AM","10-10:30 AM","10:30-11 AM","11-11:30 AM","11:30-12 AM"]
        
        let AfternoonPMTimeArray = ["12-12:30 AM","12:30-13 AM","13-13:30 AM","13:30-14 AM","14-14:30 AM","14:30-15 AM","15-15:30 AM","15:30-16 AM","16-16:30 AM","16:30-17 AM","17-17:30 AM","17:30-18 AM"]
        
        let NightPMTimeArray = ["18-18:30 PM","18:30-19 PM","19-19:30 PM","19:30-20 PM","20-20:30 PM","20:30-21 PM","21-21:30 PM","21:30-22 PM","22-22:30 PM","22:30-23 PM","23-23:30 PM","23:30-24 PM"]
        
        var nightAMAM = [String:Any]()
        nightAMAM["SelectAll"] = false
        nightAMAM["title"] = "Night(AM - AM)"
        var nightAMAMTimeArray = [[String:Any]]()
        for obj in NightAmTimeArray {
            var timeObj = [String:Any]()
            timeObj["time"] = obj
            timeObj["status"] = false
            nightAMAMTimeArray.append(timeObj)
        }
        nightAMAM["Times"] = nightAMAMTimeArray
        AvailabilityController.availabilityList?.append(nightAMAM)
        
        ////------------------
        var morningAMAM = [String:Any]()
        morningAMAM["SelectAll"] = false
        morningAMAM["title"] = "Morning(AM - AM)"
        var morningAMAMTimeArray = [[String:Any]]()
        for obj in MorningAmTimeArray {
            var timeObj = [String:Any]()
            timeObj["time"] = obj
            timeObj["status"] = false
            morningAMAMTimeArray.append(timeObj)
        }
        morningAMAM["Times"] = morningAMAMTimeArray
        AvailabilityController.availabilityList?.append(morningAMAM)
        
        ////------------------
        var afternoonPM = [String:Any]()
        afternoonPM["title"] = "Afternoon(PM - PM)"
        afternoonPM["SelectAll"] = false
        var afternoonTimeArray = [[String:Any]]()
        for obj in AfternoonPMTimeArray {
            var timeObj = [String:Any]()
            timeObj["time"] = obj
            timeObj["status"] = false
            afternoonTimeArray.append(timeObj)
        }
        afternoonPM["Times"] = afternoonTimeArray
        AvailabilityController.availabilityList?.append(afternoonPM)
        
        ////------------------
        var nightPM = [String:Any]()
        nightPM["SelectAll"] = false
        nightPM["title"] = "Evening(PM - PM)"
        var nightPMTimeArray = [[String:Any]]()
        for obj in NightPMTimeArray {
            var timeObj = [String:Any]()
            timeObj["time"] = obj
            timeObj["status"] = false
            nightPMTimeArray.append(timeObj)
        }
        nightPM["Times"] = nightPMTimeArray
        AvailabilityController.availabilityList?.append(nightPM)
        
        //        print(AvailabilityController.availabilityList as Any);
        vc.tblAddAvail.reloadData()
        AvailabilityController.tblAvail = vc.tblAddAvail;
        
    }
    
    
    static func AddAvailabilty(vc:AvailabilityViewController,dicObj:[String:Any]){
        do{
            
            vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.addavailibilityURL, params: dicObj,success: { (JSON) in
                let msg =  (JSON.dictionaryObject?["Message"] as! String)
                
                if((JSON.dictionary?["IsSuccess"]) != false){
                    let callActionHandler = { () -> Void in
                        self.ResetSelection(vc: vc)
                    }
                    Helper.ShowAlertMessageWithHandlesr(message:msg,title:""  ,vc: vc,action:callActionHandler)
                    
                }
                else{
                    let callActionHandler = { () -> Void in
                        self.ResetSelection(vc: vc)
                    }
                    Helper.ShowAlertMessageWithHandlesr(message:msg , vc: vc,action:callActionHandler)
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
    
    static func ResetSelection(vc:UIViewController){
        
        AvailabilityController.availabilityList = AvailabilityController.availabilityList.map{ originalDict in
            var newDict = originalDict as [[String:Any]]
            //            print(originalDict)
            newDict = newDict.map({ timeDic in
                var tempTimeDic = timeDic as  [String:Any]
                tempTimeDic["SelectAll"] = false
                var timeArr = tempTimeDic["Times"] as! [[String:Any]]
                timeArr = timeArr.map{ time in
                    var tempTime = time
                    tempTime["status"] = false
                    return tempTime;
                }
                tempTimeDic["Times"] = timeArr
                return tempTimeDic;
            })
            //newDict["Times"] = timeArr as! [[String:AnyObject]]
            return newDict
        }
        AvailabilityController.tblAvail?.reloadData()
        
    }
    
    static func GetAvailability(vc:AvailabilityViewController,photographerID:String){
        do{
            try
                userAvailabilityList = [[String:Any]]()
            vc.tblYourAvail.reloadData()
            vc.showSpinner()
            ApiManager.sharedInstance.requestGETURL("\(Constant.getAvailibilityURL)\(photographerID)", success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    userAvailabilityList = (JSON.dictionaryObject!["ResponseData"]) as! [[String : Any]]?;
                    //print(listCategory as Any)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblYourAvail.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
            }
            
        }
        
    }
    
}
