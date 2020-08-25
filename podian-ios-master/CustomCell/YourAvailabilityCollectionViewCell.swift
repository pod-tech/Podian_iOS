//
//  YourAvailabilityCollectionViewCell.swift
//  PODPhotographer
//
//  Created by Apple on 15/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class YourAvailabilityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var btnTime:UIButton!
    
    public func SetData(time:String){
        btnTime.setTitle(time, for: UIControl.State.normal)
        btnTime.setTitle(time, for: UIControl.State.selected)
    }
    
}
