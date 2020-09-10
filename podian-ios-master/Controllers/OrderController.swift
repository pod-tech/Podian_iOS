//
//  OrderController.swift
//  PODPhotographer
//
//  Created by Apple on 29/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift


class OrderController: NSObject {
    public static var listOrders:[[String:Any]]?
    public static var listTempOrders:[[String:Any]]?
    public static var listOrderDetails:[[String:Any]]?
    public static var listNotification:[[String:Any]]?
    public static var listByTimeOrders:[[String:Any]]?
    
    static func GetOrders(userId:String,vc:OrdersViewController){
        do{
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestGETURL(Constant.getOrderByPhotographerIDURL+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                listOrders = [[String:Any]]()
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listOrders = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                    self.FilterData(index: 1);
                    //                    print(listOrders as Any)
                }
                else{
                    // Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblOrder?.reloadData()
                vc.refreshControl.endRefreshing()
                vc.tblOrder.isHidden = false;
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
                vc.tblOrder.isHidden = false;
            }
        }
    }
    
    static func GetOrdersByTime(userId:String,vc:OrderByTimeViewController,type:Int){
        do{
            try
                vc.showSpinner()
            var url:String = ""
            if(type == 1){
                url = Constant.getTodayOrderByPhotohrapherIdURL
            }
            else if(type == 2){
                url = Constant.getTommorowOrderByPhotohrapherIdURL
            }
            else if(type == 3){
                url = Constant.getWeekOrderByPhotohrapherIdURL
            }
            else if(type == 4){
                url = Constant.getOrderByPhotographerIDURL
            }
            ApiManager.sharedInstance.requestGETURL(url+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                listByTimeOrders = [[String:Any]]()
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listByTimeOrders = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
                    listByTimeOrders = listByTimeOrders?.filter{($0["Status"] as! String) != "6"}
//                    print(listByTimeOrders as Any)
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblOrder?.reloadData()
                vc.tblOrder.isHidden = false;
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
                vc.tblOrder.isHidden = false;
            }
        }
    }
    
    static func GetOrdersDetails(userId:String,orderID:String,vc:OrderDetailViewController){
        do{
            try
                vc.showSpinner()
            if(listOrderDetails != nil){
                listOrderDetails?.removeAll();
                vc.tblOrders?.reloadData()
            }
            ApiManager.sharedInstance.requestGETURL("\(Constant.GetOrderDetailURL+userId)/\(orderID)", success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                listOrderDetails = [[String:Any]]()
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listOrderDetails = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                    print(listOrderDetails as Any)
                    if(vc.isCompletedOrder==false){
                        listOrderDetails = listOrderDetails?.filter{($0["Status"] as! String) != "6"}
                    }
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblOrders?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func FilterData(index:Int){
        if(index == 1){
            listTempOrders = listOrders?.filter{($0["Status"] as! String) == "6"}
        } else{
            listTempOrders = listOrders?.filter{($0["Status"] as! String) == "6"}
        }
    }
    
    static func SendOrderOTPtoCustomer(vc:OrderDetailViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.sendOrderOTPtoCustomerURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SenOTPPopupViewController") as! SenOTPPopupViewController
                    
                    controller.modalPresentationStyle = .overCurrentContext
                    controller.modalTransitionStyle = .crossDissolve
                    controller.dicObj = dicObj;
                    controller.vc = (vc as! OrderDetailViewController);
                    vc.present(controller, animated: true, completion: nil)
                    
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
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
    
    static func SUbmitOrderOTPtoCustomer(vc:OrderDetailViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.verifyOrderOTPURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    
                    let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
                    
                    var objDIC = [String:AnyObject]()
                    if let Id = userInfo!["Id"]{
                        objDIC["photographerId"] = Id as AnyObject
                        OrderController.GetOrdersDetails(userId: Id as! String, orderID: dicObj!["OrderId"] as! String, vc: vc)
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
    
    static func ResendOTPtoCustomer(vc:SenOTPPopupViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner(); ApiManager.sharedInstance.requestPOSTURL(Constant.reSendOrderOTPtoURL, params: dicObj, success: {
                    (JSON) in
                    let msg =  JSON.dictionary?["Message"]!
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Success",bannerStyle: BannerStyle.success)
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
    static func CompleteOrder(vc:OrderDetailViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.complateOrderByOrderIdURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    
                    let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
                    
                    var objDIC = [String:AnyObject]()
                    if let Id = userInfo!["Id"]{
                        objDIC["photographerId"] = Id as AnyObject
                        OrderController.GetOrdersDetails(userId: Id as! String, orderID: dicObj!["OrderId"] as! String, vc: vc as! OrderDetailViewController)
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
    
    static func ChangeExtSatus(vc:OrderDetailViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.extendOrderRequestChangeStatusURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    
                    let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
                    
                    var objDIC = [String:AnyObject]()
                    if let Id = userInfo!["Id"]{
                        objDIC["photographerId"] = Id as AnyObject
                        OrderController.GetOrdersDetails(userId: Id as! String, orderID: dicObj!["ExtOrderId"] as! String, vc: vc as! OrderDetailViewController)
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
    
    static func GetNotificatins(userId:String,vc:MyNotificationViewController){
        do{
            try
                listNotification = [[String:Any]]()
            vc.tblOrder?.reloadData()
            vc.showSpinner(); ApiManager.sharedInstance.requestGETURL(Constant.getNotificationbyIDURL+userId, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    listNotification = (JSON.dictionaryObject!["ResponseData"]) as? [[String:Any]];
//                    print(listNotification as Any)
                    
                }
                else{
                    //Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblOrder?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func DeleteNotificatins(userId:String,notificationID:String,vc:MyNotificationViewController){
        do{
            try
                listNotification = [[String:Any]]()
            vc.tblOrder?.reloadData()
            vc.showSpinner(); ApiManager.sharedInstance.requestGETURL(Constant.deleteNotificationbyIDURL+notificationID, success: { (JSON) in
                let msg =  JSON.dictionary?["Message"]
                if((JSON.dictionary?["IsSuccess"]) != false){
                    OrderController.GetNotificatins(userId:userId , vc: vc)
                }
                else{
                    Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                }
                vc.removeSpinner()
                vc.tblOrder?.reloadData()
                vc.refreshControl.endRefreshing()
            }) { (Error) in
                Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                vc.removeSpinner()
                vc.refreshControl.endRefreshing()
            }
        }
    }
    
    
    static func DeleteAllNotificatins(userId:String,vc:MyNotificationViewController){
        do{
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestGETURL(Constant.deleteAllNotification+userId, success: { (JSON) in
                    let msg =  JSON.dictionary?["Message"]
                    if((JSON.dictionary?["IsSuccess"]) != false){
                        //OrderController.GetNotificatins(userId:userId , vc: vc)
                        if(listNotification != nil){
                            listNotification?.removeAll();
                        }
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                    }
                    vc.removeSpinner()
                    vc.tblOrder?.reloadData()
                    vc.refreshControl.endRefreshing()
                }) { (Error) in
                    Helper.ShowAlertMessage(message: Error.localizedDescription, vc: vc,title:"Error",bannerStyle: BannerStyle.danger)
                    vc.removeSpinner()
                    vc.refreshControl.endRefreshing()
            }
        }
    }
    
    static func CheckListStatus(vc:OrderDetailViewController,dicObj:[String:AnyObject]!){
        do{
            
            try
                vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTURL(Constant.checkListURL, params: dicObj, success: {
                (JSON) in
                let msg =  JSON.dictionary?["Message"]!
                if((JSON.dictionary?["IsSuccess"]) != false){
                    vc.viewOptions.isHidden = true;
                }
                else{
                    if(msg!.description == "Checklist Added successfully"){
                        vc.viewOptions.isHidden = true;
                    }
                    else{
                        Helper.ShowAlertMessage(message:msg!.description , vc: vc,title:"Failed",bannerStyle: BannerStyle.danger)
                    }
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
    
}
