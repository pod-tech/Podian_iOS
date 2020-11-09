//
//  PracticeCell.swift
//  PODPhotographer
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class PracticeCell: UITableViewCell {

    @IBOutlet var btnCheck:UIButton!
    @IBOutlet var lblTitle:UILabel!
    var listPractive:[[String:Any]] = [[String:Any]]()
    var indexPath:IndexPath?
    var vc:FreelancerWorkInfoViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setData(dic:[String:Any],vc:FreelancerWorkInfoViewController){
        self.listPractive = vc.listPractive;
        lblTitle.text = (dic["Title"] as! String)
        self.vc = vc;
        self.btnCheck.isSelected = (dic["IsSelected"] as! Bool)
    }
    
    @IBAction func btnSelect(sender:UIButton){
        sender.isSelected = !sender.isSelected
        let dic = listPractive[indexPath!.row];
        Constant.OrderDic!["ElectivePractice"] = ""
        vc?.listPractive =  (vc?.listPractive.map{ originalDict in
            var newDict = originalDict
            if((newDict["Title"]  as! String) == (dic["Title"] as! String)){
                if((newDict["IsSelected"] as! Bool) == false){
                    newDict["IsSelected"]  = true
                    
                }
                else{
                    newDict["IsSelected"]  = false
                }
            }
            if((newDict["IsSelected"] as! Bool) == true){
                if((Constant.OrderDic!["ElectivePractice"] as! String) == ""){
                    Constant.OrderDic!["ElectivePractice"] = (newDict["Title"]  as! String)
                }
                else{
                    Constant.OrderDic!["ElectivePractice"] = "\(Constant.OrderDic!["ElectivePractice"]!),\(newDict["Title"]  as! String)"
                }
            }
            return newDict
            })!
        vc!.tblPractive.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
