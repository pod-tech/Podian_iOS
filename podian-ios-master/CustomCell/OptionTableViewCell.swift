//
//  OptionTableViewCell.swift
//  PODPhotographer
//
//  Created by Apple on 11/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet var btnOption:UIButton!
    @IBOutlet var lblTitle:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   public func Setdata(title:String,ischecked:Bool){
        self.lblTitle.text = title;
        self.btnOption.isSelected = ischecked;
    }

}
