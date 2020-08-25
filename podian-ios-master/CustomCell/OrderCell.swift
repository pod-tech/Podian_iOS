//
//  OrderCell.swift
//  PODPhotographer
//
//  Created by Apple on 01/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet var viewBG:UIView?
    @IBOutlet var lblDate:UILabel!
    @IBOutlet var lblStartTime:UILabel!
    @IBOutlet var lblTotalHrs:UILabel!
    @IBOutlet var lblStatus:UILabel!
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
           viewBG?.layer.cornerRadius = 10;
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func SetData(dic:[String:AnyObject]){
           
            
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
            
            if let  status = dic["Status"]{
                let statusName = Helper.GetOrderStatusName(index:Int(status as! String)!)
                lblStatus.text = "Status: \(statusName)";
                    lblStatus.halfTextColorChange(fullText: lblStatus.text!, changeText: statusName, color: UIColor.init(hexString: "#81C283"))
            }
            
            
        }

}
