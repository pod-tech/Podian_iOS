//
//  OrderByTimeViewController.swift
//  PODPhotographer
//
//  Created by Apple on 08/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class OrderByTimeViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

        @IBOutlet var tblOrder:UITableView!
        @IBOutlet var lblTitle:UILabel!
        let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:Any]
        public var type:Int!;
        public let refreshControl = UIRefreshControl()
    
        override func viewDidLoad() {
           super.viewDidLoad()
            
            tblOrder.estimatedRowHeight = 100
                  tblOrder.rowHeight = UITableView.automaticDimension
            
           self.tblOrder.isHidden = true;
           if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
           } else {
                // Fallback on earlier versions
           }
           self.tblOrder.reloadData();
           if #available(iOS 10.0, *) {
                tblOrder.refreshControl = refreshControl
           } else {
                tblOrder.addSubview(refreshControl)
            }
            self.SetStatusBarColor()
            refreshControl.addTarget(self, action: #selector(refreshAvailabilityData(_:)), for: .valueChanged)
            if(type == 1){
                lblTitle.text = "Today's Orders"
            }
            else if(type == 2){
                lblTitle.text = "Tomorrow Orders"
            }
            else if(type == 3){
                lblTitle.text = "Weekly Orders"
            }
            else if(type == 4){
                lblTitle.text = "Upcoming Orders"
            }
           
        }
        
        func GetOrderDetail(){
           var objDIC = [String:Any]()
           if let Id = userInfo!["Id"]{
              objDIC["photographerId"] = Id
              OrderController.GetOrdersByTime(userId: Id as! String, vc: self,type: self.type)
            }
       }
       @objc private func refreshAvailabilityData(_ sender: Any) {
              // Fetch Weather Data
              self.GetOrderDetail()
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.GetOrderDetail()
    }
      
    }

    extension OrderByTimeViewController {
        func numberOfSections(in tableView: UITableView) -> Int {
            1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if( OrderController.listByTimeOrders != nil){
                if( OrderController.listByTimeOrders!.count>0){
                    tableView.restore()
                }
                else{
                    tableView.setEmptyMessage("No Order Found")
                }
                return  OrderController.listByTimeOrders!.count
            }
            else{
                tableView.setEmptyMessage("No Order Found")
                return 0;
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return UITableView.automaticDimension
           }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
            cell.SetData(dic: OrderController.listByTimeOrders![indexPath.row] as [String : Any])
            return cell;
        }
        
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             let dic =  OrderController.listByTimeOrders![indexPath.row] as [String : Any]
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let controller = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
            controller.OrderID = (dic["Id"] as! String)
             self.navigationController!.pushViewController(controller, animated: true)
        }
        
}
