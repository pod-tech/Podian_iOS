//
//  FreelancerWorkInfoViewController.swift
//  PODPhotographer
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class FreelancerWorkInfoViewController: BaseViewController {

    @IBOutlet var tblPractive:UITableView!
    @IBOutlet var btn6to1:UIButton!
    @IBOutlet var btn1to3:UIButton!
    @IBOutlet var btn3to5:UIButton!
    @IBOutlet var btn5:UIButton!
    public var listPractive:[[String:Any]] = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        listPractive = FreelancerController.GetPracticeList(vc:self);
        self.tblPractive.reloadData()
        self.btn6to1.isSelected = true;
        Constant.OrderDic!["Experience"] = "6 Months - 1Yr"
        Constant.OrderDic!["ElectivePractice"] = ""
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSelectExpType(sender:UIButton){
           self.btn5.isSelected = false;
           self.btn1to3.isSelected = false;
           self.btn3to5.isSelected = false;
           self.btn6to1.isSelected = false;
           sender.isSelected = true;
        if(sender == self.btn5){
            Constant.OrderDic!["Experience"] = ">5Yrs"
        }
        else if(sender == self.btn1to3){
            Constant.OrderDic!["Experience"] = "1Yr - 3Yrs"
        }
        else if(sender == self.btn3to5){
            Constant.OrderDic!["Experience"] = "3Yrs - 5Yrs"
        }
        else if(sender == self.btn6to1){
            Constant.OrderDic!["Experience"] = "6 Months - 1Yr"
        }
        
        
       }
    
    @IBAction func btnContinue_Click(sender:UIButton){
        
        if((Constant.OrderDic!["ElectivePractice"] as! String).count == 0){
            Helper.ShowAlertMessage(message:"Please select kind of practice" , vc: self,title:"Required",bannerStyle: BannerStyle.warning)
            return;
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FreelancerSocialInfoViewController") as! FreelancerSocialInfoViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }

}

extension FreelancerWorkInfoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPractive.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PracticeCell") as! PracticeCell
        let dic = listPractive[indexPath.row];
        cell.indexPath = indexPath;
        cell.setData(dic: dic,vc: self);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = listPractive[indexPath.row];
        Constant.OrderDic!["ElectivePractice"] = ""
        listPractive = listPractive.map{ originalDict in
            var newDict = originalDict
            if((newDict["Title"]  as! String) == (dic["Title"] as! String)){
                if((newDict["IsSelected"] as! Bool) == false){
                    newDict["IsSelected"]  = true
                } else{
                    newDict["IsSelected"]  = false
                }
            }
            if((newDict["IsSelected"] as! Bool) == true){
                if((Constant.OrderDic!["ElectivePractice"] as! String) == ""){
                    Constant.OrderDic!["ElectivePractice"] = (newDict["Title"]  as! String)
                } else{
                    Constant.OrderDic!["ElectivePractice"] = "\(Constant.OrderDic!["ElectivePractice"]!),\(newDict["Title"]  as! String)"
                }
            }
            return newDict
        }
        print(Constant.OrderDic!["ElectivePractice"])
        self.tblPractive.reloadData()
    }
}
