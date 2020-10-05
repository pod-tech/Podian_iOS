//
//  ExtendPopupViewController.swift
//  PODPhotographer
//
//  Created by Apple on 31/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ExtendPopupViewController: BaseViewController {
    
    @IBOutlet var lbltitle:UILabel!
    @IBOutlet var btnAccept:UIButton!
    @IBOutlet var btnReject:UIButton?
    @IBOutlet var viewPopup:UIView!
    public var dicObj:[String:AnyObject]!
    public var vc:OrderDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        if(dicObj["ExtAvlFlg"] as! String == "No"){
            btnAccept.isHidden = true;
            btnReject!.frame = CGRect.init(x: 10, y: btnReject!.frame.origin.y, width: viewPopup.frame.size.width-20, height: 41)
            self.lbltitle.text = "Sorry, you can't accept this session because you can't available";
        }
    }
    
    @IBAction func btnClose(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnStatusSelect(sender:UIButton){
        
        var dic:[String:Any] = [String:AnyObject]();
        dic["ExtId"] = dicObj["ExtId"];
        dic["ExtOrderId"] = dicObj["ExtOrderId"];
        dic["ExtPhotographerId"] = dicObj["ExtPhotographerId"];
        dic["ExtCustomerId"] = dicObj["ExtCustomerId"];
        dic["ExtStatus"] = sender.tag.description;
        OrderController.ChangeExtSatus(vc: vc!, dicObj: dic as [String : AnyObject])
        self.dismiss(animated: true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
