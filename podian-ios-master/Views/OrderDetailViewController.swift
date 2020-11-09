//
//  OrderDetailViewController.swift
//  PODPhotographer
//
//  Created by Apple on 23/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit


class OrderDetailViewController: BaseViewController {
    
    @IBOutlet var btnUpcoming:UIButton!
    @IBOutlet var btnComplete:UIButton!
    @IBOutlet var tblOrders:UITableView!
    @IBOutlet var tblOptions:UITableView!
    @IBOutlet var viewOptions:UIView!
    var listOptionDic = [String:Bool]()
    var listOptions = [String]()
    public let refreshControl = UIRefreshControl()
    var OrderID:String?
    public var isCompletedOrder:Bool = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnUpcoming.isSelected = true;
        self.btnComplete.isSelected = false;
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        SetOptions()
        tblOrders.rowHeight = UITableView.automaticDimension
        tblOrders.estimatedRowHeight = 296
        tblOptions.rowHeight = UITableView.automaticDimension
        tblOptions.estimatedRowHeight = 50
        if #available(iOS 10.0, *) {
            tblOrders!.refreshControl = refreshControl
        } else {
            tblOrders!.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshAvailabilityData(_:)), for: .valueChanged)
        //self.GetOrderDetail()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.GetOrderDetail()
    }
    
    func SetOptions(){
        listOptionDic.removeAll()
        listOptions.removeAll()
        
        listOptionDic["Camera lens"] = false
        listOptionDic["Battery"] = false
        listOptionDic["External"] = false
        listOptionDic["Empty memory card"] = false
        listOptionDic["Additional memory card"] = false
        listOptionDic["Additional battery"] = false
        listOptionDic["Additional battery for flash light"] = false
        listOptionDic["Reach at the shoot location 10 minutes before the shoot time"] = false
        listOptionDic["Select both raw and jpg file option"] = false
        listOptionDic["Please change the file name with pod your name before every shoot"] = false
        listOptions.append("Camera lens")
        listOptions.append("Battery")
        listOptions.append("External")
        listOptions.append("Empty memory card")
        listOptions.append("Additional memory card")
        listOptions.append("Additional battery")
        listOptions.append("Additional battery for flash light")
        listOptions.append("Reach at the shoot location 10 minutes before the shoot time")
        listOptions.append("Select both raw and jpg file option")
        listOptions.append("Please change the file name with pod your name before every shoot")
        
    }
    
    func GetOrderDetail(){
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:Any]
        
        var objDIC = [String:Any]()
        if let Id = userInfo!["Id"]{
            objDIC["photographerId"] = Id
            OrderController.GetOrdersDetails(userId: Id as! String, orderID: OrderID!, vc: self)
        }
        
    }
    
    
    @objc private func refreshAvailabilityData(_ sender: Any) {
        // Fetch Weather Data
        self.GetOrderDetail()
    }
    
    @IBAction func TabAction(sender:UIButton){
        self.btnUpcoming.isSelected = false;
        self.btnComplete.isSelected = false;
        if(sender == btnUpcoming){
            OrderController.FilterData(index: 1);
        }
        else{
            OrderController.FilterData(index: 2);
        }
        sender.isSelected = true;
        self.tblOrders.reloadData()
    }
    
    @IBAction func btn_Submit(){
        var isselectAll = true;
        for (key,value) in listOptionDic {
            if(value==false){
                isselectAll = false;
            }
        }
        if(!isselectAll){
            Helper.ShowAlertMessage(message: "Select all options", vc: self)
            return
        }
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:Any]
        var otpDic = [String:Any]()
        if let Id = userInfo!["Id"]{
            otpDic["PhotographerId"] = Id
        }
        otpDic["OrderId"] = OrderID
        otpDic["Checklist"] = "YES"
        OrderController.CheckListStatus(vc: self, dicObj: otpDic)
    }
    
}

extension OrderDetailViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView==tblOrders){
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTableViewCell", for: indexPath) as! OrderDetailTableViewCell
            cell.vc = self
            cell.SetData(dic: OrderController.listOrderDetails![indexPath.row] as [String : Any])
            return cell;
        }
        else{
            
            let key = listOptions[indexPath.row];
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! OptionTableViewCell
            cell.Setdata(title: key, ischecked: listOptionDic[key]!)
            return cell;
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblOrders){
            if( OrderController.listOrderDetails != nil){
                if( OrderController.listOrderDetails!.count>0){
                    tableView.restore()
                }
                else{
                    tableView.setEmptyMessage("No Order Found")
                }
                return  OrderController.listOrderDetails!.count
            }
            else{
                tableView.setEmptyMessage("No Order Found")
                return 0;
            }
        }
        else{
            return  listOptions.count;
        }
        
        return 0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView==tblOptions){
            let key = listOptions[indexPath.row];
            if(listOptionDic[key] == false){
                listOptionDic[key] = true
            }
            else{
                listOptionDic[key] = false
            }
            tblOptions.reloadData()
        }
    }
    
    
    
}
