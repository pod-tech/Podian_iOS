//
//  SettingViewController.swift
//  PODPhotographer
//
//  Created by Apple on 08/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnInfo_Click(sender:UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        if(sender.tag == 1){
            controller.headerTitle = "About Us"
            controller.slug = "about-us";
        }
        else if(sender.tag == 2){
            controller.headerTitle = "Privacy Policy"
            controller.slug = "privacy-and-policy";
        }
        else if(sender.tag == 3){
                   controller.headerTitle = "Terms & Conditions"
            controller.slug = "term-and-condition";
        }
        else if(sender.tag == 4){
             controller.headerTitle = "Contact Us"
            controller.slug = "contact-us";
        }
        //let controller = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func btnLogout_Click(sender:UIButton){
        UserDefaults.standard.removeObject(forKey: "UserInfo")
        UserDefaults.standard.synchronize()
         var isPresent:Bool = false;
                   var findVc:UIViewController?
                   if let viewControllers = navigationController?.viewControllers {
                       for viewController in viewControllers {
                           // some process
                           if viewController is  LoginViewController{
                               isPresent = true;
                               findVc = viewController;
                               break;
                           }
                       }
                   }
                   if(isPresent){
                       self.navigationController?.popToViewController(findVc!, animated: true)
                   }
                   else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController; self.navigationController?.viewControllers.insert(controller, at: 1); self.navigationController?.popToViewController(controller, animated: true)
                   }
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
