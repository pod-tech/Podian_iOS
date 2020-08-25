//
//  NotificationTableCell.swift
//  POD
//
//  Created by Apple on 12/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    @IBOutlet var lblContent:UILabel!
    @IBOutlet var lblDate:UILabel!
    var indexPath:IndexPath = [];
    var vc:MyNotificationViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
    }
    
    @IBAction func btnDelete(sender:UIButton){
        
        let deleteAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)
        if #available(iOS 13.0, *) {
            deleteAlert.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            let obj = OrderController.listNotification![self.indexPath.row] as [String:AnyObject];
            OrderController.DeleteNotificatins(userId: obj["customerId"] as! String, notificationID: obj["Id"] as! String, vc: self.vc)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        vc.present(deleteAlert, animated: true, completion: nil)
    }

}
