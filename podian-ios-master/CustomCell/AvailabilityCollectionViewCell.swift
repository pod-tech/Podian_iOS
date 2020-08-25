//
//  AvailabilityCollectionViewCell.swift
//  PODPhotographer
//
//  Created by Apple on 15/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AvailabilityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet  var btnTime:UIButton!
    var indexPath:IndexPath?
    var parentIndexPath:IndexPath?
    var timeObj:[String:AnyObject]?
    
    public func SetData(dic:[String:AnyObject],indexPath:IndexPath,parentIndex:IndexPath){
        self.timeObj = dic;
        self.indexPath = indexPath;
        self.parentIndexPath = parentIndex;
        btnTime.setTitle((dic["time"] as! String), for: UIControl.State.normal)
         btnTime.setTitle((dic["time"] as! String), for: UIControl.State.selected)
        btnTime.isSelected = (dic["status"] as! Bool)
    }
    
    @IBAction func btnSelect_Click(sender:UIButton){
        sender.isSelected = !sender.isSelected
        self.timeObj!["status"] = sender.isSelected as AnyObject
        var mainObj = AvailabilityController.availabilityList?[parentIndexPath!.row]
        var arrtime = mainObj!["Times"] as! [[String:AnyObject]]
        arrtime[indexPath!.row] = self.timeObj!
        mainObj!["Times"] = arrtime as AnyObject;
        
        var status:Bool = true;
        for time in arrtime {
            if((time["status"] as! Bool) == false){
                status = false;
                break;
            }
        }
        if(status){
            mainObj?["SelectAll"] = true as AnyObject
        }
        else{
            mainObj?["SelectAll"] = false as AnyObject
        }
    AvailabilityController.availabilityList?[parentIndexPath!.row] = mainObj!
        AvailabilityController.tblAvail?.reloadData()
    }
    
    
    
}
