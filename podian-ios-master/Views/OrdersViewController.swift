//
//  OrdersViewController.swift
//  PODPhotographer
//
//  Created by Apple on 01/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {

    @IBOutlet var btnUpcoming:UIButton!
    @IBOutlet var btnComplete:UIButton!
    @IBOutlet var viewOrders:UIView!
    public let refreshControl = UIRefreshControl()
    @IBOutlet var tblOrder:UITableView!
    let userInfo = Helper.UnArchivedUserDefaultObject(key: "UserInfo") as? [String:AnyObject]
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        tblOrder.estimatedRowHeight = 100
        tblOrder.rowHeight = UITableView.automaticDimension
        
       self.btnUpcoming.isSelected = true;
       self.btnComplete.isSelected = false;
       self.tblOrder.isHidden = true;
       self.viewOrders.isHidden = false;
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
        self.GetOrderDetail()
    }
    
    func GetOrderDetail(){
       var objDIC = [String:AnyObject]()
       if let Id = userInfo!["Id"]{
          objDIC["photographerId"] = Id as AnyObject
          OrderController.GetOrders(userId: Id as! String, vc: self)
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
              //OrderController.FilterData(index: 1);
            self.tblOrder.isHidden = true;
            self.viewOrders.isHidden = false;
          }
          else{
            self.tblOrder.isHidden = false;
            self.viewOrders.isHidden = true;
            OrderController.FilterData(index: 2);
          }
          sender.isSelected = true;
          self.tblOrder.reloadData()
      }
    
    @IBAction func TimeSelectedbAction(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      let controller = storyboard.instantiateViewController(withIdentifier: "OrderByTimeViewController") as! OrderByTimeViewController
        controller.type = sender.tag; Helper.rootNavigation?.pushViewController(controller, animated: true)
    }
}

extension OrdersViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
          1
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if( OrderController.listTempOrders != nil){
               if( OrderController.listTempOrders!.count>0){
                   tableView.restore()
               }
               else{
                    tableView.setEmptyMessage("No Order Found")
               }
               return  OrderController.listTempOrders!.count
           } else{
               tableView.setEmptyMessage("No Order Found")
               return 0;
           }
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.SetData(dic: OrderController.listTempOrders![indexPath.row] as [String : AnyObject])
        //cell.vc = self;
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         var dic =  OrderController.listTempOrders![indexPath.row] as [String : AnyObject]
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let controller = storyboard.instantiateViewController(withIdentifier: "OrderDetailViewController") as! OrderDetailViewController
        controller.OrderID = (dic["Id"] as! String)
        controller.isCompletedOrder = true;
         self.navigationController!.pushViewController(controller, animated: true)
    }
    
}
