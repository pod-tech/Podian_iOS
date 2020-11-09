//
//  FreelancerController.swift
//  PODPhotographer
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift
class FreelancerController: NSObject {
    
    static func GetPracticeList(vc:FreelancerWorkInfoViewController)-> [[String:Any]]{
        var listPracticeValue = [String]()
        listPracticeValue.append("Couple Photography")
        listPracticeValue.append("Body Photography(New Born-Syrs)")
        listPracticeValue.append("Product Photography(Bags/Jewellery/Shoes/Machinery etc)")
        listPracticeValue.append("Fashion Photography")
        listPracticeValue.append("Food Photography")
        listPracticeValue.append("Group Events(Birthday/Baby Shower/Engagement etc)")
        listPracticeValue.append("Interior Photography(Corporate/Personal)")
        listPracticeValue.append("Corporate Photography(Meetings/Events/Celebrations etc)")
        listPracticeValue.append("Potrait Photography")
        listPracticeValue.append("Candids")
        
        var listPractice = [[String:Any]]()
        for val in listPracticeValue {
            var obj = [String:Any]()
            obj["Title"] = val 
            obj["IsSelected"] = false
            listPractice.append(obj)
        }
        
        return listPractice;
    }
    
    public static var listMedia:[String]?
    public static var listJoinUs:[String]?
    public static func SetList(){
        listMedia = [String]()
        listMedia?.append("Facebook")
        listMedia?.append("Instagram")
        listMedia?.append("Firends")
        listMedia?.append("Other")
        
        listJoinUs = [String]()
        listJoinUs?.append("STUDIO")
        listJoinUs?.append("FREELANCER")
        listJoinUs?.append("ALL OTHER")
    }
    
    static func FreelancerRegistration(vc:FreelancerSubmitInfoViewController,dicObj:[String:Any]){
        do{
            vc.showSpinner()
            ApiManager.sharedInstance.requestPOSTFreelancerMultiPartURL(endUrl: Constant.JoinFreeLancerURL, imageData: dicObj["ProfileImage"] as! Data,cardData:dicObj["IdProof"] as! Data , parameters: dicObj, success: { (JSON) in
                let result = JSON.string?.parseJSONString!
                let msg =  result!["Message"]
                if(((result!["IsSuccess"]) as! Bool) != false){
                    let callActionHandler = { () -> Void in
                        
                        for controller in vc.navigationController!.viewControllers as Array {
                            if controller.isKind(of: LoginViewController.self) {
                                vc.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        
                    }
                    Helper.ShowAlertMessageWithHandlesr(message:msg as! String , vc: vc,action:callActionHandler)
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
    
}
