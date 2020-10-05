//
//  OrderDetailTableViewCell.swift
//  PODPhotographer
//
//  Created by Apple on 24/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var lblOrderNo:UILabel?
    @IBOutlet var btnExtend:UIButton!
    @IBOutlet var lblStatus:UILabel!
    @IBOutlet var lblDate:UILabel!
    @IBOutlet var lblStartTime:UILabel!
    @IBOutlet var lblTotalHrs:UILabel!
    @IBOutlet var lblEndTime:UILabel!
    @IBOutlet var lblShootType:UILabel!
    //    @IBOutlet var txtLocation:UITextView!
    @IBOutlet var btnSubmitOTP:UIButton!
    @IBOutlet var btnCall:UIButton!
    @IBOutlet var lblExtendHrs:UILabel!
    @IBOutlet var lblExtendTime:UILabel!
    @IBOutlet var lblRemainingTime:UILabel!
    @IBOutlet var btnFullCall:UIButton!
    @IBOutlet var btnLocation:UIButton!
    @IBOutlet var btnChat:UIButton!
    @IBOutlet var viewCall:UIView!
    @IBOutlet weak var lblMeeting: UILabel!
    @IBOutlet var heightConstaintButtonLocation:NSLayoutConstraint!
    @IBOutlet var btnCallWidthContaraint:NSLayoutConstraint!
    @IBOutlet var heightConstaintRemainingTIme:NSLayoutConstraint!
    @IBOutlet var heightExtendTIme:NSLayoutConstraint!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet var heightCallView:NSLayoutConstraint!
    @IBOutlet var heightAddTitle:NSLayoutConstraint!
    @IBOutlet var widthExtend:NSLayoutConstraint!
    public var indexPath:IndexPath?;
    public var dicObj:[String:AnyObject]?;
    public var vc = OrderDetailViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        txtLocation.contentOffset = .zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnGetDirection(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BookingDetailAddressViewController") as! BookingDetailAddressViewController
        
        let latitude = dicObj!["ShootingLat"]
        let longitude = dicObj?["ShootingLng"]
        let lat = Double(((latitude?.description)!))!
        let lng = Double(((longitude?.description)!))!
        controller.lat = lat;
        controller.lng = lng;
        controller.add = (dicObj!["ShootingAddress"] as! String)
        vc.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func SendOTP(sender:UIButton){
        if(sender.tag != 5){
            var dic:[String:Any] = [String:AnyObject]();
            dic["OrderId"] = dicObj!["Id"];
            dic["PhotographerId"] = dicObj!["PhotographerId"];
            dic["CustomerId"] = dicObj!["CustomerId"];
            OrderController.SendOrderOTPtoCustomer(vc: vc, dicObj: dic as [String : AnyObject])
        } else{
            var dic:[String:Any] = [String:AnyObject]();
            dic["OrderId"] = dicObj!["Id"];
            OrderController.CompleteOrder(vc: vc, dicObj: dic as [String : AnyObject])
        }
    }
    
    @IBAction func btnExtendClick(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller : ExtendPopupViewController = storyboard.instantiateViewController(withIdentifier: "ExtendPopupViewController") as! ExtendPopupViewController
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.dicObj = dicObj!;
        controller.vc = vc
        vc.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btnChatClick(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        controller.dicObj = dicObj!;
        vc.navigationController?.pushViewController(controller, animated: true)
    }
    
    func SetData(dic:[String:AnyObject]){
        self.dicObj = dic;
        self.btnFullCall.isHidden = true
        self.btnChat.isHidden = true
        self.widthExtend.constant = 0;
        if let  orderNO = dic["OrderNo"]{
            lblOrderNo!.text = "Order Id: \(orderNO)";
            lblOrderNo!.halfTextColorChange(fullText:lblOrderNo!.text, changeText: orderNO as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            
        }
        
        
        if let  DisplayFlg = dic["DisplayFlg"]{
            if((DisplayFlg as! String) == "Yes"){
                self.viewCall.isHidden = false;
                self.heightCallView.constant = 42
                heightAddTitle.constant = 18
                self.btnLocation.isHidden = false
                self.btnChat.isHidden = false
                if let  Address = dic["ShootingAddress"]{
                    lblAddress.text = Address as? String
                    lblAddress.textColor = UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1)
                }
                
                if let  meetPoint = dic["ShootingMeetPoint"]{
                    lblMeeting!.text = "Meeting Point: \(meetPoint)"
                    lblMeeting!.halfTextColorChange(fullText:lblMeeting!.text, changeText: meetPoint as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
                }
            } else{
                self.viewCall.isHidden = true;
                self.heightCallView.constant = 0
                self.btnLocation.isHidden = true
                lblAddress.text = ""
                lblMeeting.text = ""
                heightAddTitle.constant = 0
                btnChat.isHidden = true
                
            }
        }
        if let  ExtReqFlg = dic["ExtReqFlg"]{
            if((ExtReqFlg as! String) == "Yes"){
                self.btnExtend.isHidden = false
            }
            else{
                self.btnExtend.isHidden = true
            }
        }
        if let  ExtAvlFlg = dic["ExtAvlFlg"]{
            if((ExtAvlFlg as! String) == "Yes"){
                
            }
            else{
                
            }
        }
        
        if let  ShootingDate = dic["ShootingDate"]{
            lblDate.text = "Date: \(ShootingDate)";
            lblDate.halfTextColorChange(fullText:lblDate.text!, changeText: ShootingDate as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            
        }
        if let  ShootingHours = dic["ShootingHours"]{
            lblTotalHrs.text = "Total Hrs: \(ShootingHours)";
            lblTotalHrs.halfTextColorChange(fullText:lblTotalHrs.text!, changeText: ShootingHours as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            
        }
        
        if let  ShootingStartTime = dic["ShootingStartTime"]{
            lblStartTime.text = "Start Time: \(ShootingStartTime) O'Clock";
            lblStartTime.halfTextColorChange(fullText:lblStartTime.text!, changeText: "\(ShootingStartTime) O'Clock", color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            
        }
        if let  ShootingeEndTime = dic["ShootingeEndTime"]{
            lblEndTime.text = "End Time: \(ShootingeEndTime) O'Clock";
            lblEndTime.halfTextColorChange(fullText:lblEndTime.text!, changeText: "\(ShootingeEndTime) O'Clock", color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
            let remainingTime = Helper.TimeDiff(endTime: ShootingeEndTime as! String)
            lblRemainingTime.text = "Remaining Time: \(remainingTime)";
        }
        if let  ExtEndTime = dic["ExtEndTime"]{
            lblExtendTime.text = "Ext End Time: \(ExtEndTime)";
            lblExtendTime.halfTextColorChange(fullText:lblExtendTime.text!, changeText: ExtEndTime as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        if let  ExtHours = dic["ExtHours"]{
            lblExtendHrs.text = "Extend Hrs: \(ExtHours)";
            lblExtendHrs.halfTextColorChange(fullText:lblExtendHrs.text!, changeText: ExtHours as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        
        
        if let  ProductTitle = dic["ProductTitle"]{
            lblShootType.text = "Shoot Type: \(ProductTitle)";
            lblShootType.halfTextColorChange(fullText:lblShootType.text!, changeText: ProductTitle as! String, color: UIColor.init(red: 19/255, green: 57/255, blue: 145/255, alpha: 1))
        }
        if let  ExtAddress = dic["ExtAddress"]{
            if(ExtAddress as! String != "0"){
                lblAddress.text = ExtAddress as? String;
            }
            
        }
        if let  status = dic["Status"]{
            self.btnExtend.isHidden = true;
            let statusName = Helper.GetOrderStatusName(index:Int(status as! String)!)
            lblStatus.text = "Status: \(statusName)"
            lblStatus.halfTextColorChange(fullText:lblStatus.text!, changeText: statusName, color: UIColor.init(red: 285/255, green: 185/255, blue: 59/255, alpha: 1))
            
            self.btnCallWidthContaraint.constant = 0
            self.heightConstaintRemainingTIme.constant = 42
            self.heightConstaintButtonLocation.constant = 42
            if(status as! String == "5"){
                self.btnChat.isHidden = true;
                self.lblRemainingTime.isHidden = false;
                self.heightConstaintRemainingTIme.constant = 20;
                self.btnSubmitOTP.setTitle("Complete Shooting", for: UIControl.State.normal)
                self.btnSubmitOTP.tag = 5
                if let  ExtStatus = dic["ExtStatus"]{
                    if(ExtStatus as! String == "1"){
                        self.btnExtend.isHidden = false;
                        self.widthExtend.constant = 50;
                    }
                }
            } else{
                self.lblRemainingTime.isHidden = true;
                self.heightConstaintRemainingTIme.constant = 0;
                if(status as! String == "6"){
                    self.btnCallWidthContaraint.constant = 42
                    self.heightConstaintButtonLocation.constant = 0
                    self.heightConstaintRemainingTIme.constant = 0;
                    self.btnLocation.isHidden = true;
                    self.btnFullCall.isHidden = false
                    self.btnChat.isHidden = true;
                } else if(status as! String == "2" || status as! String == "5"){
                    if let  ExtStatus = dic["ExtStatus"]{
                        if(ExtStatus as! String == "1"){
                            self.btnExtend.isHidden = false;
                            self.widthExtend.constant = 50;
                        }
                    }
                    
                }
            }
            
            if(status as! String == "2" || status as! String == "3" || status as! String == "5" || status as! String == "6"){
                
                lblStatus.halfTextColorChange(fullText: lblStatus.text!, changeText: statusName, color: UIColor.init(hexString: "#81C283"))
                
            }
        }
        if let  ExtStatus = dic["ExtStatus"]{
            self.heightExtendTIme.constant = 0;
            if(ExtStatus as! String == "2"){
                lblExtendHrs.isHidden = false;
                lblExtendTime.isHidden = false;
                self.heightExtendTIme.constant = 20;
            }
            else{
                lblExtendHrs.isHidden = true;
                lblExtendTime.isHidden = true;
            }
        }
        
        if let  CheckFlg = dic["CheckFlg"]{
            if(CheckFlg as! String == "No"){
                if let  DisplayCheckList = dic["DisplayCheckList"]{
                    if(DisplayCheckList as! String == "Yes"){
                        vc.viewOptions.isHidden = false;
                    } else {
                        vc.viewOptions.isHidden = true;
                    }
                }
            }
            else{
                vc.viewOptions.isHidden = true;
            }
        }
        
        //        if let DisplayChatFlg = dic["DisplayChatFlg"]{
        //
        //            if((DisplayChatFlg as! String) != "Yes"){
        //                self.btnChat.isHidden = true
        //            }
        //            else{
        //                self.btnChat.isHidden = true
        //            }
        //        }
        
        
    }
    
}
